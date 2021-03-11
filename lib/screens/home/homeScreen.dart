import 'package:flutter/material.dart';
import 'package:pa8/models/User.dart';
import 'package:pa8/routes/routes.dart';
import 'package:pa8/services/AuthenticationService.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/homeScreen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    UserData user = Provider.of<UserData>(context);

    return Scaffold(
      appBar: AppBar(actions: <Widget>[_actionAppBar(user)]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, Routes.analyse);
        },
        child: Icon(Icons.camera_alt),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget _actionAppBar(UserData user) {
    if (user == null) {
      return IconButton(
        icon: const Icon(Icons.person_add),
        tooltip: 'Se connecter',
        onPressed: () async {
          await AuthenticationService.signInWithGoogle();
        },
      );
    } else {
      return IconButton(
        icon: const Icon(Icons.person),
        tooltip: 'Mon profile',
        onPressed: () async {
          Navigator.pushNamed(context, Routes.profile);
        },
      );
    }
  }
}
