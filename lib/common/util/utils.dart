import 'dart:io';

import 'package:enough_giphy_flutter/enough_giphy_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

const defultProfilePic = "https://i.stack.imgur.com/l60Hf.png";

void showSnakBar({required BuildContext context, required String content}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

Future<File?> pickImageFromGallery(BuildContext context) async {
  File? image;
  try {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  } catch (e) {
    showSnakBar(context: context, content: e.toString());
  }
  return image;
}

Future<File?> pickVideoFromGallery(BuildContext context) async {
  File? video;
  try {
    final pickedVideo =
        await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (pickedVideo != null) {
      video = File(pickedVideo.path);
    }
  } catch (e) {
    showSnakBar(context: context, content: e.toString());
  }
  return video;
}

Future<GiphyGif?> pickGIF(BuildContext context) async {
  //FQenmk3A0oevJUpheC2aRecV9ZUVE692
  GiphyGif? gif;
  try {
    gif = await Giphy.getGif(
      context: context,
      apiKey: 'FQenmk3A0oevJUpheC2aRecV9ZUVE692',
    );
  } catch (e) {
    showSnakBar(context: context, content: e.toString());
  }
  return gif;
}
