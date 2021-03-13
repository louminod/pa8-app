import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pa8/models/Analyse.dart';
import 'package:pa8/models/User.dart';
import 'package:pa8/services/APIService.dart';
import 'package:pa8/widgets/Error.dart';
import 'package:pa8/widgets/Loading.dart';

class AnalyseScreen extends StatefulWidget {
  static const String routeName = '/analyseScreen';

  final String imagePath;
  final UserData user;

  const AnalyseScreen({Key key, this.imagePath, this.user}) : super(key: key);

  @override
  _AnalyseScreenState createState() => _AnalyseScreenState();
}

class _AnalyseScreenState extends State<AnalyseScreen> {
  @override
  Widget build(BuildContext _context) {
    return FutureBuilder(
      future: ApiService.makeAnalyseOfImage(widget.user, File(widget.imagePath)),
      builder: (_context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            Analyse analyse = snapshot.data;
            return _showResults(_context, analyse);
          } else {
            return ErrorScaffold(text: "Analyse impossible");
          }
        } else {
          return LoadingScaffold();
        }
      },
    );
  }

  Widget _showResults(BuildContext _context, Analyse analyse) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              child: Card(
                elevation: 5,
                child: Image.file(analyse.image),
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
          Navigator.pop(_context);
        },
        child: Icon(Icons.save),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
