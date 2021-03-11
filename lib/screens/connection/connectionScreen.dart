import 'package:flutter/material.dart';
import 'package:pa8/services/AuthenticationService.dart';

class ConnectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ElevatedButton(
          child: Text("Se connecter"),
          onPressed: () async {
            await AuthenticationService.signInWithGoogle();
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
