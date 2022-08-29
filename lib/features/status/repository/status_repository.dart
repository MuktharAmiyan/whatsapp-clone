import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_ui/common/util/utils.dart';
import 'package:whatsapp_ui/features/chat/widgets/contacts_list.dart';
import 'package:whatsapp_ui/models/status_model.dart';
import 'package:whatsapp_ui/models/user_model.dart';

import '../../../common/repository/common_firebase_repository.dart';

final statusRepositoryProvider = Provider(
  (ref) => StatusRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    ref: ref,
  ),
);

class StatusRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final ProviderRef ref;
  StatusRepository({
    required this.firestore,
    required this.auth,
    required this.ref,
  });

  void uploadStatus({
    required String username,
    required String profilePic,
    required String phoneNumber,
    required File statusImage,
    required BuildContext context,
  }) async {
    try {
      String uid = auth.currentUser!.uid;
      String imageurl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase(
            '/status/$uid',
            statusImage,
          );

      List<Contact> contacts = [];
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }

      List<String> uidWhoCanSee = [];

      for (int i = 0; i < contacts.length; i++) {
        var userDataFirebase = await firestore
            .collection('users')
            .where('phoneNumber',
                isEqualTo: contacts[i].phones[0].number.replaceAll(' ', ''))
            .get();

        if (userDataFirebase.docs.isNotEmpty) {
          var userData = UserModel.fromMap(userDataFirebase.docs[0].data());
          uidWhoCanSee.add(userData.uid);
        }
      }

      List<String> statusImageUrls = [];
      var statusesSnapshot = await firestore
          .collection('status')
          .where(
            'uid',
            isEqualTo: auth.currentUser!.uid,
          )
          .get();

      if (statusesSnapshot.docs.isNotEmpty) {
        Status status = Status.fromMap(statusesSnapshot.docs[0].data());
        statusImageUrls = status.photoUrl;
        statusImageUrls.add(imageurl);
        await firestore
            .collection('status')
            .doc(statusesSnapshot.docs[0].id)
            .update({
          'photoUrl': statusImageUrls,
        });
        return;
      } else {
        statusImageUrls = [imageurl];
      }

      Status status = Status(
        uid: uid,
        userName: username,
        phoneNumber: phoneNumber,
        photoUrl: statusImageUrls,
        createdAt: DateTime.now(),
        profilePic: profilePic,
        statusId: uid,
        whoCanSee: uidWhoCanSee,
      );

      await firestore.collection('status').doc(uid).set(status.toMap());
    } catch (e) {
      showSnakBar(context: context, content: e.toString());
    }
  }

  Future<List<Status>> getStatus(BuildContext context) async {
    List<Status> statusData = [];
    try {
      List<Contact> contacts = [];
      List<String> listContact = [];
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }

      for (var i = 0; i < contacts.length; i++) {
        listContact.add(contacts[i].phones[0].number.replaceAll(' ', ''));
      }

      var statusesSnapshot = await firestore
          .collection('status')
          .where('phoneNumber', whereIn: listContact)
          .where(
            'createdAt',
            isGreaterThan: DateTime.now()
                .subtract(const Duration(hours: 24))
                .millisecondsSinceEpoch,
          )
          .where('whoCanSee', arrayContains: auth.currentUser!.uid)
          .get();
      statusData.addAll(List.generate(statusesSnapshot.docs.length,
          (index) => Status.fromMap(statusesSnapshot.docs[index].data())));
    } catch (e) {
      showSnakBar(context: context, content: e.toString());
    }
    return statusData;
  }
}
