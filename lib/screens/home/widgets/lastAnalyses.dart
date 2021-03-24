import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pa8/models/Analyse.dart';
import 'package:pa8/models/User.dart';
import 'package:pa8/screens/analyse/analyseScreen.dart';

class LastAnalysesWidget extends StatelessWidget {
  final UserData user;
  final List<Analyse> analyses;

  LastAnalysesWidget(this.user, this.analyses);

  @override
  Widget build(BuildContext _context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(_context).size.height / 1.7,
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: analyses.length,
        itemBuilder: (_context, index) {
          Analyse analyse = analyses[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  _context, MaterialPageRoute(builder: (_context) => AnalyseScreen(analyse: analyse, user: user)));
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Card(
                elevation: 5,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: ListTile(
                    leading: user == null ? Image.file(File(analyse.imageUrl)) : Image.network(analyse.imageUrl),
                    title: Text(analyse.title),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${analyse.date}'),
                        Text("${analyse.moleType.toString().split('.')[1]} | ${analyse.risk} %"),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
