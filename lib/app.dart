import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pa8/routes/routes.dart';
import 'package:pa8/screens/analyse/analyseScreen.dart';
import 'package:pa8/screens/home/homeScreen.dart';
import 'package:pa8/screens/profile/profileScreen.dart';
import 'package:pa8/tools/wrapper.dart';
import 'package:pa8/utils/constants.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(Constants.ORIENTATIONS_ALLOWED);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: _routes(context),
      home: Wrapper.userDataWrapper(HomeScreen()),
    );
  }

  Map<String, Widget Function(BuildContext)> _routes(BuildContext context) {
    return {
      Routes.home: (context) => Wrapper.userDataWrapper(HomeScreen()),
      Routes.analyse: (context) => Wrapper.userDataWrapper(AnalyseScreen()),
      Routes.profile: (context) => Wrapper.userDataWrapper(ProfileScreen()),
    };
  }
}
