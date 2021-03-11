import 'package:flutter/material.dart';
import 'package:pa8/models/User.dart';
import 'package:pa8/routes/routes.dart';
import 'package:pa8/services/AuthenticationService.dart';
import 'package:pa8/widgets/Loading.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = '/profileScreen';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    UserData user = Provider.of<UserData>(context);

    return user == null
        ? LoadingScaffold()
        : Scaffold(
            appBar: AppBar(
              title: Text(user.userName),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.logout),
                  tooltip: 'Se deconnecter',
                  onPressed: () async {
                    await AuthenticationService.signOut();
                    Navigator.pushNamedAndRemoveUntil(context, Routes.home, (Route<dynamic> route) => false);
                  },
                ),
              ],
            ),
          );
  }
}
