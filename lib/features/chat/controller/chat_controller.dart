import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/common/enums/message_enum.dart';
import 'package:whatsapp_ui/common/providers/message_replay_provider.dart';
import 'package:whatsapp_ui/features/auth/controller/auth_controller.dart';

import 'package:whatsapp_ui/features/chat/repository/chat_repository.dart';
import 'package:whatsapp_ui/models/chat_contact.dart';
import 'package:whatsapp_ui/models/message.dart';

final chatControllerprovider = Provider((ref) {
  final chatRepository = ref.watch(chatRepositoryprovider);
  return ChatController(chatRepository: chatRepository, ref: ref);
});

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;
  ChatController({
    required this.chatRepository,
    required this.ref,
  });
  void sendTextMessage(
    BuildContext context,
    String text,
    String recieverUserId,
  ) {
    final messageReplay = ref.read(messageReplayprovider);
    ref.read(userDataAuthProvider).whenData((value) {
      log(value.toString());
      return chatRepository.sendTextmessage(
          context: context,
          text: text,
          recieverUserId: recieverUserId,
          senderUser: value!,
          messageReplay: messageReplay);
    });
  }

  void sendFileMessage(
    BuildContext context,
    File file,
    String recieverUserId,
    MessageEnum messageEnum,
  ) {
    final messageReplay = ref.read(messageReplayprovider);
    ref.read(userDataAuthProvider).whenData((value) {
      log(value.toString());
      return chatRepository.sendFileMessage(
          context: context,
          file: file,
          reciverUserid: recieverUserId,
          senderUserData: value!,
          ref: ref,
          messageEnum: messageEnum,
          messageReplay: messageReplay);
    });
  }

  void sendGIFMessage(
      BuildContext context, String gifUrl, String revieverUserId) {
    int gifUrlPartIndex = gifUrl.lastIndexOf('-') + 1;
    String gifUrlPart = gifUrl.substring(gifUrlPartIndex);
    String NewUrl = "https://i.giphy.com/media/$gifUrlPart/200.gif";
    print(NewUrl);
    final messageReplay = ref.read(messageReplayprovider);
    ref.read(userDataAuthProvider).whenData(
          (value) => chatRepository.sendGIFmessage(
              context: context,
              gifUrl: NewUrl,
              recieverUserId: revieverUserId,
              senderUser: value!,
              messageReplay: messageReplay),
        );
  }

  Stream<List<ChatContact>> chatContacts() {
    return chatRepository.getChatContacts();
  }

  Stream<List<Message>> chatStream(String reciverUserId) {
    return chatRepository.getChatStream(reciverUserId);
  }
}
