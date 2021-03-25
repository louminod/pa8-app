import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

abstract class StorageService {
  static firebase_storage.FirebaseStorage _storageFirebase = firebase_storage.FirebaseStorage.instance;

  static Future<String> getFileDownloadUrl(String fileRef) async {
    return await _storageFirebase.ref(fileRef).getDownloadURL();
  }

  static Future<String> uploadFile(String folder, File file) async {
    try {
      String fileName = file.path.split("/")[file.path.split("/").length - 1];
      await firebase_storage.FirebaseStorage.instance.ref("$folder/$fileName").putFile(File(file.path));
      return await _storageFirebase.ref("$folder/$fileName").getDownloadURL();
    } on FirebaseException catch (e) {
      print("file upload error !");
      print(e.message);
    }
    return null;
  }

  static Future<File> downloadFile(String filePath, String fileRef) async {
    File file = File(filePath);

    try {
      await firebase_storage.FirebaseStorage.instance.ref(fileRef).writeToFile(file);
    } on FirebaseException catch (e) {
      print("file download error !");
      print(e.message);
    }
    return file;
  }
}
