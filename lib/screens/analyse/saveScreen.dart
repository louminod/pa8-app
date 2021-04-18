import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pa8/models/Analyse.dart';
import 'package:pa8/models/User.dart';
import 'package:pa8/routes/routes.dart';
import 'package:pa8/services/DatabaseService.dart';
import 'package:pa8/widgets/Loading.dart';
import 'package:uuid/uuid.dart';

class SaveScreen extends StatefulWidget {
  final Analyse analyse;
  final Analyse lastAnalyse;
  final UserData user;

  const SaveScreen({Key key, this.analyse, this.user, this.lastAnalyse}) : super(key: key);

  @override
  _SaveScreenState createState() => _SaveScreenState();
}

class _SaveScreenState extends State<SaveScreen> {
  final _formKey = GlobalKey<FormState>();
  bool loading;

  @override
  void initState() {
    super.initState();
    loading = false;
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? LoadingScaffold()
        : Scaffold(
            body: Container(
              margin: EdgeInsets.all(40),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Card(
                        child: Image.file(File(widget.analyse.imageUrl), height: MediaQuery.of(context).size.height / 2.5),
                        elevation: 5,
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            widget.analyse.moleType.toString().split(".")[1],
                            style: TextStyle(color: Colors.grey, fontSize: 20),
                          ),
                          Text(
                            "|",
                            style: TextStyle(color: Colors.grey, fontSize: 20),
                          ),
                          Text(
                            "${widget.analyse.risk} %",
                            style: TextStyle(color: Colors.grey, fontSize: 20),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Text(
                        "${widget.analyse.date.toString().split(".")[0]}",
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                      SizedBox(height: 5),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Titre *',
                        ),
                        initialValue: widget.analyse.title,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Le titre ne peut être vide';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          widget.analyse.title = value;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Note',
                        ),
                        initialValue: widget.analyse.description,
                        minLines: 2,
                        maxLines: 5,
                        onChanged: (value) {
                          widget.analyse.description = value;
                        },
                      ),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                setState(() {
                                  loading = true;
                                });

                                if (widget.analyse.uid == null) {
                                  widget.analyse.uid = Uuid().v4();
                                }

                                if (widget.lastAnalyse != null) {
                                  widget.lastAnalyse.reminder = null;
                                  await DatabaseService(userUid: widget.user == null ? "" : widget.user.uid).updateAnalyse(widget.lastAnalyse);
                                }

                                await DatabaseService(userUid: widget.user == null ? "" : widget.user.uid).saveAnalyse(widget.analyse);

                                setState(() {
                                  loading = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text('Analyse sauvegardée !'),
                                  duration: Duration(seconds: 1),
                                ));
                                Navigator.pushNamedAndRemoveUntil(context, Routes.home, (Route<dynamic> route) => false);
                              }
                            },
                            child: Text('Valider'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamedAndRemoveUntil(context, Routes.home, (Route<dynamic> route) => false);
                            },
                            style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.redAccent)),
                            child: Text('Annuler'),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
