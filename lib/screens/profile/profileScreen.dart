import 'package:flutter/material.dart';
import 'package:pa8/models/User.dart';
import 'package:pa8/models/references/UserType.dart';
import 'package:pa8/routes/routes.dart';
import 'package:pa8/services/AuthenticationService.dart';
import 'package:pa8/services/DatabaseService.dart';
import 'package:pa8/widgets/Loading.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = '/profileScreen';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext _context) {
    UserData user = Provider.of<UserData>(context);

    if (user == null) {
      return LoadingScaffold();
    }

    return user.userType == UserType.CLIENT ? _profileClient(_context, user) : _profileDoctor(_context, user);
  }

  Widget _profileClient(BuildContext _context, UserData user) {
    return Scaffold(
      appBar: _appBar(_context),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(user.profilePicture),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(height: 5),
            Text(user.userName, style: TextStyle(fontSize: 20)),
            SizedBox(height: 15),
            Text("Code client: ${user.code}", style: TextStyle(fontSize: 15)),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () async {
                user.userType = UserType.DOCTOR;
                await DatabaseService(userUid: user.uid).updateUserData(user);
              },
              child: Text("Je suis dermatologue"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileDoctor(BuildContext _context, UserData user) {
    return Scaffold(
      appBar: _appBar(_context),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(user.profilePicture),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(height: 5),
            Text(user.userName, style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }

  Widget _appBar(BuildContext _context) {
    return AppBar(
      title: Text("Mon compte"),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.logout),
          tooltip: 'Se deconnecter',
          onPressed: () async {
            await AuthenticationService.signOut();
            Navigator.pushNamedAndRemoveUntil(_context, Routes.home, (Route<dynamic> route) => false);
          },
        ),
      ],
    );
  }
}
