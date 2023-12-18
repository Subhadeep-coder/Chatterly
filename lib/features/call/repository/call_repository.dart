import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/constant/utils/utils.dart';
import 'package:whatsapp/features/call/screens/call_screen.dart';
import 'package:whatsapp/models/call_model.dart';

final callRepositoryProvider = Provider(
  (ref) => CallRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  ),
);

class CallRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  CallRepository({
    required this.firestore,
    required this.auth,
  });

  Stream<DocumentSnapshot> get callStream =>
      firestore.collection('calls').doc(auth.currentUser!.uid).snapshots();

  void makeCall(
    BuildContext context,
    Call senderCallData,
    Call recieverCallData,
  ) async {
    try {
      await firestore
          .collection('calls')
          .doc(senderCallData.callerId)
          .set(senderCallData.toMap());
      await firestore
          .collection('calls')
          .doc(senderCallData.recieverId)
          .set(recieverCallData.toMap());
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallScreen(
            call: senderCallData,
            channelId: senderCallData.callId,
            isGroupChat: false,
          ),
        ),
      );
    } catch (e) {
      showSnackBar(context: context, text: e.toString());
    }
  }

  void endCall(
    BuildContext context,
    String callerId,
    String recieverId,
  ) async {
    try {
      await firestore.collection('calls').doc(callerId).delete();
      await firestore.collection('calls').doc(recieverId).delete();
    } catch (e) {
      showSnackBar(context: context, text: e.toString());
    }
  }
}
