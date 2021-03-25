import 'package:flutter/services.dart';

abstract class Constants {
  static const List<DeviceOrientation> ORIENTATIONS_ALLOWED = [
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ];

  static const API_URL = "http://10.3.1.131:1234/";

  static const DATABASE_USER = "userData";
}
