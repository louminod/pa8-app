import 'package:firebase_auth/firebase_auth.dart';
import 'package:pa8/models/references/AccountType.dart';
import 'package:pa8/models/references/UserType.dart';
import 'package:pa8/tools/converter.dart';

class UserData {
  String uid;
  String userName;
  String email;
  String profilePicture;
  UserType userType;
  AccountType accountType;

  UserData();

  UserData.extractDataFromFirebaseUser(User firebaseUser) {
    try {
      this.uid = firebaseUser.uid;
      this.userName = firebaseUser.displayName;
      this.email = firebaseUser.email;
      this.profilePicture = firebaseUser.photoURL;
    } catch (error) {
      print("ERROR -> UserData.extractDataFromFirebaseUser -> " + error.toString());
    }
  }

  UserData.fromFireStoreCollection(String uid, Map<String, dynamic> parsedJson) {
    if (parsedJson != null) {
      try {
        this.uid = uid;
        this.userName = parsedJson["userName"];
        this.email = parsedJson["email"];
        this.profilePicture = parsedJson["profilePicture"];
        this.userType = Converter.stringToUserType(parsedJson["userType"]);
        this.accountType = Converter.stringToAccountType(parsedJson["accountType"]);
      } catch (error) {
        print("ERROR -> UserData.fromFireStoreCollection -> " + error.toString());
      }
    }
  }

  Map<String, dynamic> toJson() {
    try {
      return {
        'userName': this.userName,
        'email': this.email,
        'profilePicture': this.profilePicture,
        'userType': this.userType.toString(),
        'accountType': this.accountType.toString(),
      };
    } catch (error) {
      print("ERROR -> UserData.toJson -> " + error.toString());
    }
    return null;
  }
}
