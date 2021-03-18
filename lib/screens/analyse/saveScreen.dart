import 'package:flutter/material.dart';
import 'package:pa8/models/Analyse.dart';
import 'package:pa8/routes/routes.dart';

class SaveScreen extends StatefulWidget {
  final Analyse analyse;

  const SaveScreen({Key key, this.analyse}) : super(key: key);

  @override
  _SaveScreenState createState() => _SaveScreenState();
}

class _SaveScreenState extends State<SaveScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(40),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Card(
                  child: Image.file(widget.analyse.image, height: MediaQuery.of(context).size.height / 2.5),
                  elevation: 5,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Titre',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Le titre ne peut être vide';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Note',
                  ),
                  minLines: 2,
                  maxLines: 5,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Le titre ne peut être vide';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Processing Data')));
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
