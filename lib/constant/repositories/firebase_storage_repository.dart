import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final commonFirebaseStorageRespositoryProvider = Provider((ref) =>
    CommonFirebaseStorageRespository(
        firebaseStorage: FirebaseStorage.instance));

class CommonFirebaseStorageRespository {
  final FirebaseStorage firebaseStorage;

  CommonFirebaseStorageRespository({required this.firebaseStorage});

  Future<String> storeFileToFirebase(String ref, File file) async {
    UploadTask uploadTask = firebaseStorage.ref().child(ref).putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
