import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pa8/models/Analyse.dart';
import 'package:pa8/models/User.dart';
import 'package:pa8/screens/analyse/local/analyseMaker.dart';
import 'package:pa8/tools/formater.dart';

class ReminderWidget extends StatelessWidget {
  final List<Analyse> analyses;
  final UserData user;
  final ImagePicker picker;

  const ReminderWidget(this.user, this.analyses, this.picker);

  @override
  Widget build(BuildContext context) {
    DateTime currentDate = DateTime.now();
    List<Analyse> todayReminders = [];

    if (analyses != null) {
      todayReminders = analyses.where((Analyse element) {
        if (element.reminder != null) {
          return element.reminder.compareTo(DateTime(currentDate.year, currentDate.month, currentDate.day, 23, 59)) < 1;
        } else {
          return false;
        }
      }).toList();
    }

    return todayReminders.length == 0
        ? Container()
        : Container(
            margin: EdgeInsets.only(top: 20, left: 10, right: 10),
            child: Column(
              children: [
                Text("Rappels du jour", style: TextStyle(fontSize: 20)),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: todayReminders.length,
                  itemBuilder: (context, index) {
                    Analyse analyse = todayReminders[index];
                    return Container(
                      child: Card(
                        elevation: 5,
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: Column(
                            children: [
                              ListTile(
                                leading:
                                    user == null ? Image.file(File(analyse.imageUrl)) : Image.network(analyse.imageUrl),
                                title: Text(analyse.title),
                                subtitle: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(Formater.formatDateTime(analyse.date)),
                                  ],
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: () async {
                                  final pickedFile = await picker.getImage(source: ImageSource.camera);
                                  if (pickedFile != null) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_context) => AnalyseMaker(
                                                user: user, image: File(pickedFile.path), lastAnalyse: analyse)));
                                  }
                                },
                                icon: Icon(Icons.camera_alt),
                                label: Text("Effectuer le rappel"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
  }
}
