import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp/constant/repositories/firebase_storage_repository.dart';
import 'package:whatsapp/constant/utils/utils.dart';
import 'package:whatsapp/models/status_model.dart';
import 'package:whatsapp/models/user_model.dart';

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
      var statusId = const Uuid().v1();
      String uid = auth.currentUser!.uid;
      String imageUrl = await ref
          .read(commonFirebaseStorageRespositoryProvider)
          .storeFileToFirebase('/status/$statusId/$uid', statusImage);
      print('Image Url:' + imageUrl);
      List<Contact> contacts = [];
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
      print('Going through Contacts');
      List<String> uidWhoCanSee = [];
      for (var i = 0; i < contacts.length; i++) {
        var userDataFromFirebase = await firestore
            .collection('users')
            .where('phoneNumber',
                isEqualTo: contacts[i].phones[0].number.replaceAll(' ', ''))
            .get();
        if (userDataFromFirebase.docs.isNotEmpty) {
          var userData = UserModel.fromMap(userDataFromFirebase.docs[0].data());
          uidWhoCanSee.add(userData.uid);
          print('Phone number added of:' +
              userData.name +
              'with phone number:' +
              userData.phoneNumber);
        }
      }
      print('Got all the contacts who can see status');

      List<String> statusImageUrls = [];
      var statusSnapshot = await firestore
          .collection('status')
          .where('uid', isEqualTo: auth.currentUser!.uid)
          .get();
      print('Going through all the statuses previous');
      print(statusSnapshot.docs[0].data());
      print(statusSnapshot.docs[0].id);
      if (statusSnapshot.docs.isNotEmpty) {
        Status status = Status.fromMap(statusSnapshot.docs[0].data());
        statusImageUrls = status.photoUrl;
        statusImageUrls.add(imageUrl);
        await firestore
            .collection('status')
            .doc(statusSnapshot.docs[0].id)
            .update({'photoUrl': statusImageUrls});
        print('Uploaded another status');
        return;
      } else {
        statusImageUrls = [imageUrl];
      }
      Status status = Status(
          uid: uid,
          username: username,
          phoneNumber: phoneNumber,
          photoUrl: statusImageUrls,
          createdAt: DateTime.now(),
          profilePic: profilePic,
          statusId: statusId,
          whoCanSee: uidWhoCanSee);
      await firestore.collection('status').doc(statusId).set(status.toMap());
      print('Uploaded new status');
    } catch (e) {
      showSnackBar(context: context, text: e.toString());
    }
  }

  Future<List<Status>> getStatus(BuildContext context) async {
    List<Status> statusData = [];
    try {
      List<Contact> contacts = [];
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
      for (var i = 0; i < contacts.length; i++) {
        var statusesSnapshot = await firestore
            .collection('status')
            .where(
              'phoneNumber',
              isEqualTo: contacts[i].phones[0].number.replaceAll(
                    ' ',
                    '',
                  ),
            )
            .where(
              'createdAt',
              isGreaterThan: DateTime.now()
                  .subtract(const Duration(hours: 24))
                  .millisecondsSinceEpoch,
            )
            .get();
        for (var tempData in statusesSnapshot.docs) {
          Status tempStatus = Status.fromMap(tempData.data());
          if (tempStatus.whoCanSee.contains(auth.currentUser!.uid)) {
            statusData.add(tempStatus);
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      showSnackBar(context: context, text: e.toString());
    }
    return statusData;
  }
}
