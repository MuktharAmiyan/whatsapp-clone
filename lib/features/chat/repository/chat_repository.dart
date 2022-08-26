import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_ui/common/enums/message_enum.dart';
import 'package:whatsapp_ui/common/providers/message_replay_provider.dart';
import 'package:whatsapp_ui/common/repository/common_firebase_repository.dart';
import 'package:whatsapp_ui/common/util/utils.dart';
import 'package:whatsapp_ui/info.dart';
import 'package:whatsapp_ui/models/chat_contact.dart';
import 'package:whatsapp_ui/models/message.dart';
import 'package:whatsapp_ui/models/user_model.dart';

final chatRepositoryprovider = Provider((ref) => ChatRepository(
    firestore: FirebaseFirestore.instance, auth: FirebaseAuth.instance));

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ChatRepository({
    required this.firestore,
    required this.auth,
  });
  Stream<List<ChatContact>> getChatContacts() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
      List<ChatContact> contacts = [];
      for (var document in event.docs) {
        var chatContact = ChatContact.fromMap(document.data());
        var userData =
            await firestore.collection('users').doc(chatContact.contctId).get();
        var user = UserModel.fromMap(userData.data()!);
        contacts.add(ChatContact(
            name: user.name,
            profilePic: user.profilePic,
            contctId: chatContact.contctId,
            timeSent: chatContact.timeSent,
            lastMessage: chatContact.lastMessage));
      }
      return contacts;
    });
  }

  Stream<List<Message>> getChatStream(String reciverUserId) {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(reciverUserId)
        .collection('messages')
        .orderBy('timeSent')
        .snapshots()
        .map((event) {
      List<Message> messages = [];
      for (var document in event.docs) {
        messages.add(Message.fromMap(document.data()));
      }
      return messages;
    });
  }

  void _saveDataToContactSubcollection(
    UserModel senderUserData,
    UserModel reciverUserData,
    String text,
    DateTime timeSent,
    String recieverUserId,
  ) async {
    var reciverChatContact = ChatContact(
      name: senderUserData.name,
      profilePic: senderUserData.profilePic,
      contctId: senderUserData.uid,
      timeSent: timeSent,
      lastMessage: text,
    );
    await firestore
        .collection('users')
        .doc(recieverUserId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .set(reciverChatContact.toMap());

    var senderChatContact = ChatContact(
      name: reciverUserData.name,
      profilePic: reciverUserData.profilePic,
      contctId: reciverUserData.uid,
      timeSent: timeSent,
      lastMessage: text,
    );
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(recieverUserId)
        .set(senderChatContact.toMap());
  }

  void _saveMessageToMessageSubcollection({
    required String reciverUserId,
    required String text,
    required DateTime timeSent,
    required String messageId,
    required String userName,
    required String reviverUserName,
    required MessageEnum messageType,
    required MessageReplay? messageReplay,
    required String senderUserName,
    required String receiverUserName,
  }) async {
    final message = Message(
        senderId: auth.currentUser!.uid,
        reviverId: reciverUserId,
        text: text,
        type: messageType,
        timeSent: timeSent,
        messageId: messageId,
        isSeen: false,
        replaiedMessage: messageReplay == null ? '' : messageReplay.message,
        replayMessageType: messageReplay == null
            ? MessageEnum.text
            : messageReplay.messageEnum,
        repliedTo: messageReplay == null
            ? ''
            : messageReplay.isMe
                ? senderUserName
                : receiverUserName);
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(reciverUserId)
        .collection('messages')
        .doc(messageId)
        .set(message.toMap());

    await firestore
        .collection('users')
        .doc(reciverUserId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .collection('messages')
        .doc(messageId)
        .set(message.toMap());
  }

  void sendTextmessage(
      {required BuildContext context,
      required String text,
      required String recieverUserId,
      required UserModel senderUser,
      required MessageReplay? messageReplay}) async {
    try {
      var timeSent = DateTime.now();
      UserModel reciverUserData;
      var userDataMap =
          await firestore.collection('users').doc(recieverUserId).get();
      reciverUserData = UserModel.fromMap(userDataMap.data()!);
      var messageId = const Uuid().v1();
      _saveDataToContactSubcollection(
        senderUser,
        reciverUserData,
        text,
        timeSent,
        recieverUserId,
      );
      _saveMessageToMessageSubcollection(
        reciverUserId: recieverUserId,
        text: text,
        timeSent: timeSent,
        messageId: messageId,
        userName: senderUser.name,
        reviverUserName: reciverUserData.name,
        messageType: MessageEnum.text,
        messageReplay: messageReplay,
        receiverUserName: reciverUserData.name,
        senderUserName: senderUser.name,
      );
    } catch (e) {
      showSnakBar(context: context, content: e.toString());
    }
  }

  void sendFileMessage(
      {required BuildContext context,
      required File file,
      required String reciverUserid,
      required UserModel senderUserData,
      required ProviderRef ref,
      required MessageEnum messageEnum,
      required MessageReplay? messageReplay}) async {
    try {
      var timeSent = DateTime.now();
      var messageId = Uuid().v1();
      String fileUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase(
              'chat/${messageEnum.type}/${senderUserData.uid}/$reciverUserid/$messageId',
              file);

      UserModel reciverUserData;
      var userDataMap =
          await firestore.collection('users').doc(reciverUserid).get();
      reciverUserData = UserModel.fromMap(userDataMap.data()!);
      String contactMsg;
      switch (messageEnum) {
        case MessageEnum.image:
          contactMsg = "📷 Photo";
          break;
        case MessageEnum.video:
          contactMsg = "🎥 Video";
          break;
        case MessageEnum.audio:
          contactMsg = "🎵 Audio";
          break;
        case MessageEnum.gif:
          contactMsg = "GIF";
          break;
        default:
          contactMsg = "GIF";
      }

      _saveDataToContactSubcollection(
        senderUserData,
        reciverUserData,
        contactMsg,
        timeSent,
        reciverUserid,
      );
      _saveMessageToMessageSubcollection(
        reciverUserId: reciverUserid,
        text: fileUrl,
        timeSent: timeSent,
        messageId: messageId,
        userName: senderUserData.name,
        reviverUserName: reciverUserData.name,
        messageType: messageEnum,
        messageReplay: messageReplay,
        receiverUserName: reciverUserData.name,
        senderUserName: senderUserData.name,
      );
    } catch (e) {
      showSnakBar(context: context, content: e.toString());
    }
  }

  void sendGIFmessage(
      {required BuildContext context,
      required String gifUrl,
      required String recieverUserId,
      required UserModel senderUser,
      required MessageReplay? messageReplay}) async {
    try {
      var timeSent = DateTime.now();
      UserModel reciverUserData;
      var userDataMap =
          await firestore.collection('users').doc(recieverUserId).get();
      reciverUserData = UserModel.fromMap(userDataMap.data()!);
      var messageId = const Uuid().v1();
      _saveDataToContactSubcollection(
        senderUser,
        reciverUserData,
        "GIF",
        timeSent,
        recieverUserId,
      );
      _saveMessageToMessageSubcollection(
        reciverUserId: recieverUserId,
        text: gifUrl,
        timeSent: timeSent,
        messageId: messageId,
        userName: senderUser.name,
        reviverUserName: reciverUserData.name,
        messageType: MessageEnum.gif,
        messageReplay: messageReplay,
        receiverUserName: reciverUserData.name,
        senderUserName: senderUser.name,
      );
    } catch (e) {
      showSnakBar(context: context, content: e.toString());
    }
  }
}
