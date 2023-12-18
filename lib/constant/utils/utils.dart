import 'package:enough_giphy_flutter/enough_giphy_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

void showSnackBar({required BuildContext context, required String text}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}

Future<File?> pickImageFromGallary(BuildContext context) async {
  File? image;
  try {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  } catch (e) {
    showSnackBar(context: context, text: e.toString());
  }
  return image;
}

Future<File?> pickVideoFromGallary(BuildContext context) async {
  File? video;
  try {
    final pickedVideo =
        await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (pickedVideo != null) {
      video = File(pickedVideo.path);
    }
  } catch (e) {
    showSnackBar(context: context, text: e.toString());
  }
  return video;
}

Future<GiphyGif?> pickGIF(BuildContext context) async {
  // 6xoEtqafawlU4nvAlpJB8cFDy6vZw65j
  GiphyGif? gif;
  try {
    gif = await Giphy.getGif(
      context: context,
      apiKey: '6xoEtqafawlU4nvAlpJB8cFDy6vZw65j',
    );
  } catch (e) {
    showSnackBar(context: context, text: e.toString());
  }
  return gif;
}
