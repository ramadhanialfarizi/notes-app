import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart' as fire_core;

class UploadHandler {
  final storage = FirebaseStorage.instance;

  Future<void> uploadImage(String filePath, String fileName) async {
    File file = File(filePath);
    final storageRef = FirebaseStorage.instance.ref('pages/').child(fileName);

    try {
      await storageRef.putFile(file);
    } on fire_core.FirebaseException catch (e) {
      print(e);
    }
  }

  Future<ListResult> listFile() async {
    ListResult result = await storage.ref('pages').listAll();

    print(result);

    return result;
  }

  Future<String> getURLImage(String imageName) async {
    String getUrl = await storage.ref('pages/$imageName').getDownloadURL();

    return getUrl;
  }
}
