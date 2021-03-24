import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pa8/models/Analyse.dart';
import 'package:pa8/models/User.dart';
import 'package:pa8/screens/analyse/saveScreen.dart';

class AnalyseScreen extends StatelessWidget {
  static const String routeName = '/analyseScreen';

  final Analyse analyse;
  final UserData user;

  const AnalyseScreen({Key key, this.analyse, this.user}) : super(key: key);

  @override
  Widget build(BuildContext _context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              child: Card(
                elevation: 5,
                child: Image.file(File(analyse.imageUrl)),
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    analyse.moleType.toString().split(".")[1],
                    style: TextStyle(color: Colors.grey, fontSize: 30),
                  ),
                  Text(
                    "|",
                    style: TextStyle(color: Colors.grey, fontSize: 30),
                  ),
                  Text(
                    "${analyse.risk} %",
                    style: TextStyle(color: Colors.grey, fontSize: 30),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.push(
            _context,
            MaterialPageRoute(
              builder: (_context) => SaveScreen(
                analyse: analyse,
                user: user,
              ),
            ),
          );
        },
        child: Icon(Icons.save),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
