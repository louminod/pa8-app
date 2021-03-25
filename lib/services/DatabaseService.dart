import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pa8/models/Analyse.dart';
import 'package:pa8/models/User.dart';
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

  Stream<UserData> get userData {
    if (this.userUid != "") {
      return _usersDataCollection
          .doc(userUid)
          .snapshots()
          .map((snapshot) => UserData.fromFireStoreCollection(snapshot.id, snapshot.data()));
    } else {
      return null;
    }
  }

  Future<void> createUserData(UserData userData) async {
    final snapShot = await _usersDataCollection.doc(userData.uid).get();

    if (snapShot == null || !snapShot.exists) {
      _usersDataCollection.doc(userData.uid).set(userData.toJson());
    }
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

  Future<List<Analyse>> get analyses async {
    if (this.userUid == "") {
      return _loadLocalAnalyses();
    } else {
      /*QuerySnapshot q = await _usersDataCollection.doc(userUid).collection(DatabasePath.userBookings).get();
      Booking last;
      q.docs.forEach((element) {
        Booking booking = new Booking.fromFireStoreCollection(element.id, element.data());
        if (last == null) {
          last = booking;
        } else if (booking.bookingTimeSlot.start.compareTo(last.bookingTimeSlot.start) == 1) {
          last = booking;
        }
      });
      return last;

       */
    }
  }

  Future<void> saveAnalyse(Analyse analyse) {
    if (this.userUid == "") {
      _saveAnalyseLocally(analyse);
    } else {}

    return null;
  }

  Future<void> deleteAnalyse(Analyse analyse) async {
    await _deleteLocalAnalyse(analyse);
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
}
