import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void showSnackbar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

Future<File?> pickImage() async {
  final ImagePicker picker = ImagePicker();
  final imageFile =
      await picker.pickImage(source: ImageSource.camera, imageQuality: 30);
  if (imageFile != null) {
    return File(imageFile.path);
  }
  return null;
}
