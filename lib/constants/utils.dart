import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    )
  );
}

Future<List<File>> pickImages() async {
  List<File> images = [];
  try {
    var filesResult = await FilePicker.platform.pickFiles(type: FileType.image, allowMultiple: true);

    //check if filesResult not null and the files that they give us is not empty
    if (filesResult != null && filesResult.files.isNotEmpty) {
      for (final file in filesResult.files) {
        images.add(File(file.path!));
      }
    }
  } catch (error) {
    debugPrint(error.toString());
  }

  return images;
}