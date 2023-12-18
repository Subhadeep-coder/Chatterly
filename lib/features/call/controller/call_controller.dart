import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp/features/auth/controller/auth_controller.dart';
import 'package:whatsapp/features/call/repository/call_repository.dart';
import 'package:whatsapp/models/call_model.dart';

final callControllerProvider = Provider((ref) {
  final callRepository = ref.read(callRepositoryProvider);
  return CallController(
    callRepository: callRepository,
    auth: FirebaseAuth.instance,
    ref: ref,
  );
});

class CallController {
  final CallRepository callRepository;
  final FirebaseAuth auth;
  final ProviderRef ref;

  CallController({
    required this.callRepository,
    required this.ref,
    required this.auth,
  });

  Stream<DocumentSnapshot> get callStream => callRepository.callStream;

  void makeCall(
    BuildContext context,
    String recieverName,
    String recieverUid,
    String recieverProfilePic,
    bool isGroupChat,
  ) {
    ref.read(userDataAuthProvider).whenData((value) {
      String callId = const Uuid().v1();
      Call senderCallData = Call(
        callerId: auth.currentUser!.uid,
        callerName: value!.name,
        callerPic: value.profilePic,
        recieverId: recieverUid,
        recieverName: recieverName,
        recieverPic: recieverProfilePic,
        callId: callId,
        hasDialled: true,
      );
      Call recieverCallData = Call(
        callerId: auth.currentUser!.uid,
        callerName: value.name,
        callerPic: value.profilePic,
        recieverId: recieverUid,
        recieverName: recieverName,
        recieverPic: recieverProfilePic,
        callId: callId,
        hasDialled: false,
      );
      callRepository.makeCall(context, senderCallData, recieverCallData);
    });
  }

  void endCall(
    BuildContext context,
    String callerId,
    String recieverId,
  ) {
    callRepository.endCall(context, callerId, recieverId);
  }
}
