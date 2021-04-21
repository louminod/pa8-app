import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pa8/models/Analyse.dart';
import 'package:pa8/models/User.dart';
import 'package:pa8/services/StorageService.dart';
import 'package:pa8/services/references/DatabasePath.dart';
import 'package:pa8/utils/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:uuid/uuid.dart';

class DatabaseService {
  static DatabaseFactory _storageLocal = databaseFactoryIo;

  final String userUid;

  DatabaseService({this.userUid}) : assert(userUid != null, 'Cannot create DatabaseService with null user uid');

  final _usersDataCollection = FirebaseFirestore.instance.collection(Constants.DATABASE_USER);

  // USERDATA

  Stream<UserData> get userDataStream {
    if (this.userUid != "") {
      return _usersDataCollection.doc(userUid).snapshots().map((snapshot) => UserData.fromFireStoreCollection(snapshot.id, snapshot.data()));
    } else {
      return null;
    }
  }

  Future<List<UserData>> get listUserDataFuture async {
    List<UserData> users = [];

    QuerySnapshot snapshot = await _usersDataCollection.get();
    snapshot.docs.forEach((doc) {
      if (doc.exists) {
        users.add(UserData.fromFireStoreCollection(doc.id, doc.data()));
      }
    });

    return users;
  }

  Future<UserData> get userDataFuture async {
    DocumentSnapshot snapshot = await _usersDataCollection.doc(userUid).get();
    if (snapshot.exists) {
      var data = snapshot.data();
      return UserData.fromFireStoreCollection(snapshot.id, data);
    } else {
      return null;
    }
  }

  Future<void> createUserData(UserData userData) async {
    try {
      final snapShot = await _usersDataCollection.doc(userData.uid).get();

      if (snapShot == null || !snapShot.exists) {
        return _usersDataCollection.doc(userData.uid).set(userData.toJson());
      }
    } catch (error) {
      print("ERROR -> createUserData -> ${error.toString()}");
    }
    return null;
  }

  Future<void> updateUserData(UserData userData) {
    try {
      return _usersDataCollection.doc(userData.uid).update(userData.toJson());
    } catch (error) {
      print("ERROR -> updateUserData -> ${error.toString()}");
    }
    return null;
  }

  Future<void> deleteUserData(UserData userData) => _usersDataCollection.doc(userData.uid).delete();

  // ANALYSES

  Future<List<Analyse>> get analysesFuture async {
    return _loadLocalAnalyses();
  }

  Stream<List<Analyse>> get analysesStream => _usersDataCollection
      .doc(userUid)
      .collection(DatabasePath.usersAnalyses)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => Analyse.fromFireStoreCollection(doc.id, doc.data())).toList());

  Future<void> saveAnalyse(Analyse analyse) async {
    _saveAnalyseLocally(analyse);
    if (this.userUid != "") {
      _saveAnalyseFirebase(analyse);
    }
    return null;
  }

  Future<void> updateAnalyse(Analyse analyse) async {
    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    Database db = await _storageLocal.openDatabase(appDocDirectory.path + "/pa8");
    var store = StoreRef.main();

    await store.record(analyse.uid).update(db, analyse.toJson());
    if (this.userUid != "") {
      try {
        _usersDataCollection.doc(userUid).collection(DatabasePath.usersAnalyses).doc(analyse.uid).update(analyse.toJson());
      } catch (error) {
        print(error.toString());
      }
    }

    return null;
  }

  Future<void> deleteAnalyse(Analyse analyse) async {
    await _deleteLocalAnalyse(analyse);
    if (this.userUid != "") {
      try {
        _usersDataCollection.doc(userUid).collection(DatabasePath.usersAnalyses).doc(analyse.uid).delete();
      } catch (error) {
        print(error.toString());
      }
    }
  }

  Future _saveAnalyseLocally(Analyse analyse) async {
    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    Database db = await _storageLocal.openDatabase(appDocDirectory.path + "/pa8");
    var store = StoreRef.main();

    List<Analyse> localAnalyses = await _loadLocalAnalyses();
    List<String> keys = [];
    localAnalyses.forEach((element) => keys.add(element.uid));

    if (keys.contains(analyse.uid)) {
      await store.record(analyse.uid).update(db, analyse.toJson());
    } else {
      localAnalyses.sort((a, b) => a.date.compareTo(b.date));
      if (localAnalyses.length == 5) {
        await store.record(localAnalyses[0].uid).delete(db);
      }

      analyse.uid = Uuid().v4();
      await store.record(analyse.uid).put(db, analyse.toJson());
    }
  }

  Future _saveAnalyseFirebase(Analyse analyse) async {
    try {
      analyse.imageUrl = await StorageService.uploadFile(userUid + "/" + analyse.uid, File(analyse.imageUrl));
      return _usersDataCollection.doc(userUid).collection(DatabasePath.usersAnalyses).doc(analyse.uid).set(analyse.toJson());
    } catch (error) {
      print("ERROR -> _saveAnalyseFirebase -> " + error.toString());
    }
    return null;
  }

  Future<List<Analyse>> _loadLocalAnalyses() async {
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

  Future<List<Analyse>> _loadFirebaseAnalyses() async {
    QuerySnapshot q = await _usersDataCollection.doc(userUid).collection(DatabasePath.usersAnalyses).get();
    List<Analyse> analyses = [];
    q.docs.forEach((element) {
      analyses.add(new Analyse.fromFireStoreCollection(element.id, element.data()));
    });
    return analyses;
  }

  Future _deleteLocalAnalyse(Analyse analyse) async {
    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    Database db = await _storageLocal.openDatabase(appDocDirectory.path + "/pa8");
    var store = StoreRef.main();

    return store.record(analyse.uid).delete(db);
  }

  Future _cleanLocalStorage() async {
    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    Database db = await _storageLocal.openDatabase(appDocDirectory.path + "/pa8");
    var store = StoreRef.main();

    List<Analyse> localAnalyses = await _loadLocalAnalyses();
    List<String> keys = [];
    localAnalyses.forEach((element) => keys.add(element.uid));

    return store.records(keys).delete(db);
  }

  Future syncDatabases() async {
    List<Analyse> localAnalyses = await _loadLocalAnalyses();
    List<Analyse> firebaseAnalyses = await _loadLocalAnalyses();
    Map<String, Analyse> both = new Map();

    localAnalyses.forEach((analyse) async {
      await saveAnalyse(analyse);
    });

    return null;
  }
}
