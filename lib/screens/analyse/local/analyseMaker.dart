import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pa8/models/Analyse.dart';
import 'package:pa8/models/User.dart';
import 'package:pa8/screens/analyse/analyseScreen.dart';
import 'package:pa8/services/APIService.dart';
import 'package:pa8/widgets/Error.dart';
import 'package:pa8/widgets/Loading.dart';

class AnalyseMaker extends StatelessWidget {
  final Analyse lastAnalyse;
  final UserData user;
  final File image;

  const AnalyseMaker({Key key, this.user, this.image, this.lastAnalyse}) : super(key: key);

  @override
  Widget build(BuildContext _context) {
    return FutureBuilder(
      future: ApiService.makeAnalyseOfImage(user, image),
      builder: (_context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            Analyse analyse = snapshot.data;
            return AnalyseScreen(analyse: analyse, user: user, lastAnalyse: lastAnalyse);
          } else {
            return ErrorScaffold(text: "Analyse impossible");
          }
        } else {
          return Scaffold(
            body: Container(
              color: Color(0xff00364B),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/wip.gif",
                      fit: BoxFit.fitHeight,
                    ),
                    Text("Analyse en cours...", style: TextStyle(color: Colors.white,fontSize: 20)),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
