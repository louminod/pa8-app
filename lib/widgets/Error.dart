import 'package:flutter/material.dart';
import 'package:pa8/routes/routes.dart';

class ErrorScaffold extends StatelessWidget {
  final String text;

  const ErrorScaffold({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext _context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(this.text),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(_context, Routes.home, (Route<dynamic> route) => false);
                },
                child: Text("Accueil"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
