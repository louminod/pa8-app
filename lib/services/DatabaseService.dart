import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pa8/models/User.dart';
import 'package:pa8/utils/constants.dart';

class DatabaseService {
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
}
