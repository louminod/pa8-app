import 'package:flutter/material.dart';
import 'package:pa8/routes/routes.dart';
import 'package:pa8/screens/connection/connectionScreen.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/homeScreen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.person_add),
          tooltip: 'Se connecter',
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ConnectionScreen()));
          },
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, Routes.analyse);
        },
        child: Icon(Icons.camera_alt),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget _actionAppBar() {

  }
}
