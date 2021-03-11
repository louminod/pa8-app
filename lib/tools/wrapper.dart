import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pa8/models/User.dart';
import 'package:pa8/services/AuthenticationService.dart';
import 'package:pa8/services/DatabaseService.dart';
import 'package:provider/provider.dart';

abstract class Wrapper {
  static Widget userDataWrapper(Widget page) {
    return StreamBuilder<User>(
      stream: AuthenticationService.userFirebase,
      builder: (context, AsyncSnapshot<User> userFirebaseSnapshot) {
        String userUid = "";
        if (userFirebaseSnapshot.hasData) {
          userUid = userFirebaseSnapshot.data.uid;
        }
        return StreamProvider<UserData>.value(
          value: DatabaseService(userUid: userUid).userData,
          initialData: null,
          child: page,
        );
      },
    );
  }
}
