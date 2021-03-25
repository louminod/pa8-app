import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pa8/models/Analyse.dart';
import 'package:pa8/models/User.dart';
import 'package:pa8/routes/routes.dart';
import 'package:pa8/screens/analyse/saveScreen.dart';
import 'package:pa8/services/DatabaseService.dart';
import 'package:pa8/services/StorageService.dart';

class AnalyseScreen extends StatelessWidget {
  static const String routeName = '/analyseScreen';

  final Analyse analyse;
  final UserData user;

  const AnalyseScreen({Key key, this.analyse, this.user}) : super(key: key);

  @override
  Widget build(BuildContext _context) {
    return Scaffold(
      appBar: AppBar(
        actions: analyse.title == null
            ? []
            : [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await DatabaseService(userUid: user == null ? "" : user.uid).deleteAnalyse(analyse);
                    Navigator.pushNamedAndRemoveUntil(_context, Routes.home, (Route<dynamic> route) => false);
                  },
                ),
              ],
      ),
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
            Row(
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
            analyse.title != null
                ? Text(
                    analyse.title,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  )
                : Container(),
            analyse.description != null ? Text(analyse.description) : Container(),
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
        child: Icon(analyse.title == null ? Icons.save : Icons.edit),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
