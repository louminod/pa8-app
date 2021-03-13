import 'dart:io';

import 'package:flutter/material.dart';
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
            return Scaffold(
              appBar: AppBar(),
            );
          } else {
            return ErrorScaffold(text: "Analyse impossible");
          }
        } else {
          return LoadingScaffold();
        }
      },
    );
  }
}
