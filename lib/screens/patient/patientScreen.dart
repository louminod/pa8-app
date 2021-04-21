import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pa8/models/Analyse.dart';
import 'package:pa8/models/User.dart';
import 'package:pa8/models/references/MoleType.dart';
import 'package:pa8/screens/analyse/analyseScreen.dart';
import 'package:pa8/services/DatabaseService.dart';
import 'package:pa8/tools/formater.dart';
import 'package:pa8/widgets/Loading.dart';

class PatientScreen extends StatelessWidget {
  final UserData user;
  final UserData patient;

  const PatientScreen({Key key, this.user, this.patient}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(patient.userName),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: DatabaseService(userUid: patient.uid).analysesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              List<Analyse> analyses = snapshot.data;
              analyses.sort((a, b) => b.date.compareTo(a.date));
              return ListView.builder(
                shrinkWrap: true,
                itemCount: analyses.length,
                itemBuilder: (context, index) {
                  Analyse analyse = analyses[index];
                  Color color = Colors.white;
                  switch (analyse.moleType) {
                    case MoleType.BENIGN:
                      color = Colors.green;
                      break;
                    case MoleType.MALIGNANT:
                      color = Colors.redAccent;
                      break;
                    default:
                      color = Colors.grey;
                      break;
                  }
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_context) => AnalyseScreen(analyse: analyse, user: user)));
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: Card(
                        color: color,
                        elevation: 5,
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            leading: analyse.imageUrl.contains("emulated") || analyse.imageUrl.contains("data")
                                ? Image.file(File(analyse.imageUrl))
                                : Image.network(analyse.imageUrl),
                            title: Text(analyse.title, style: TextStyle(color: Colors.white)),
                            subtitle: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(Formater.formatDateTime(analyse.date), style: TextStyle(color: Colors.white)),
                                Text("${analyse.moleType.toString().split('.')[1]} | ${analyse.risk} %", style: TextStyle(color: Colors.white)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return Container();
            }
          } else {
            return LoadingWidget();
          }
        },
      ),
    );
  }
}
