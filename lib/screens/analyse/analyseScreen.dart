import 'dart:io';
import 'package:intl/date_symbol_data_local.dart';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:pa8/models/Analyse.dart';
import 'package:pa8/models/User.dart';
import 'package:pa8/models/references/UserType.dart';
import 'package:pa8/routes/routes.dart';
import 'package:pa8/screens/analyse/saveScreen.dart';
import 'package:pa8/services/DatabaseService.dart';

class AnalyseScreen extends StatelessWidget {
  static const String routeName = '/analyseScreen';

  final Analyse lastAnalyse;
  final Analyse analyse;
  final UserData user;

  const AnalyseScreen({Key key, this.analyse, this.user, this.lastAnalyse}) : super(key: key);

  @override
  Widget build(BuildContext _context) {
    return Scaffold(
      appBar: AppBar(
        actions: user.userType == UserType.CLIENT
            ? [
                IconButton(
                  icon: const Icon(Icons.alarm),
                  onPressed: () async {
                    _reminderModal(_context);
                  },
                ),
                analyse.title == null
                    ? Container()
                    : IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          await DatabaseService(userUid: user == null ? "" : user.uid).deleteAnalyse(analyse);
                          Navigator.pushNamedAndRemoveUntil(_context, Routes.home, (Route<dynamic> route) => false);
                        },
                      ),
              ]
            : [],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              child: Card(
                elevation: 5,
                child: analyse.bytes != null
                    ? Image.memory(analyse.bytes)
                    : analyse.imageUrl.contains("emulated") || analyse.imageUrl.contains("data")
                        ? Image.file(File(analyse.imageUrl))
                        : Image.network(analyse.imageUrl),
              ),
            ),
            analyse.risk >= 0
                ? Row(
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
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "La photo n'a pas pu être analysée (erreur : ${analyse.moleType.toString().split(".")[1]})",
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
      floatingActionButton: user.userType == UserType.CLIENT
          ? FloatingActionButton(
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
            )
          : null,
    );
  }

  _reminderModal(BuildContext context) {
    initializeDateFormatting();
    showModalBottomSheet(
        context: context,
        builder: (context) {
          DateTime selectedDate;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(20),
                child: Text(
                  "Définir un rappel",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, bottom: 30),
                child: DateTimePicker(
                  type: DateTimePickerType.dateTimeSeparate,
                  dateMask: 'd MMM, yyyy',
                  initialValue: analyse.reminder == null ? DateTime.now().toString() : analyse.reminder.toString(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                  icon: Icon(Icons.event),
                  dateLabelText: 'Date',
                  timeLabelText: "Hour",
                  locale: Locale('fr', 'FR'),
                  onChanged: (val) {
                    selectedDate = DateTime.parse(val);
                  },
                  onSaved: (val) => print(val),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: ElevatedButton(
                  onPressed: () async {
                    analyse.reminder = selectedDate;
                    if (analyse.uid != null) {
                      await DatabaseService(userUid: user == null ? "" : user.uid).updateAnalyse(analyse);
                    }
                    Navigator.pop(context);
                  },
                  child: Text("Valider"),
                ),
              )
            ],
          );
        });
  }
}
