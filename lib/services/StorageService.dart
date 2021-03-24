import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:pa8/models/Analyse.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:uuid/uuid.dart';

abstract class StorageService {
  static firebase_storage.FirebaseStorage _storageFirebase = firebase_storage.FirebaseStorage.instance;
  static DatabaseFactory _storageLocal = databaseFactoryIo;

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

  static Future saveAnalyseLocally(Analyse analyse) async {
    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    Database db = await _storageLocal.openDatabase(appDocDirectory.path + "/pa8");
    var store = StoreRef.main();

    List<Analyse> localAnalyses = await loadLocalAnalyses();
    localAnalyses.sort((a, b) => a.date.compareTo(b.date));
    if (localAnalyses.length == 5) {
      await store.record(localAnalyses[0].uid).delete(db);
    }

    analyse.uid = Uuid().v4();
    await store.record(analyse.uid).put(db, analyse.toJson());
  }

  static Future<List<Analyse>> loadLocalAnalyses() async {
    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    Database db = await _storageLocal.openDatabase(appDocDirectory.path + "/pa8");
    var store = StoreRef.main();

    List<RecordSnapshot<dynamic, dynamic>> records = await store.find(db);
    List<Analyse> analyses = [];
    records.forEach((element) async {
      analyses.add(Analyse.fromJson(element.value));
    });
    analyses.sort((a, b) => b.date.compareTo(a.date));
    return analyses;
  }

  static Future cleanLocalStorage() async {
    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    Database db = await _storageLocal.openDatabase(appDocDirectory.path + "/pa8");
    var store = StoreRef.main();

    List<Analyse> localAnalyses = await loadLocalAnalyses();
    List<String> keys = [];

    localAnalyses.forEach((element) => keys.add(element.uid));

    return store.records(keys).delete(db);
  }

  static Future<List<Analyse>> loadFirebaseAnalyses() async {
    List<Analyse> analyses = [];
    return analyses;
  }
}
