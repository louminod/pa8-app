import 'package:flutter/services.dart';

abstract class Constants {
  static const List<DeviceOrientation> ORIENTATIONS_ALLOWED = [
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ];

  static const API_URL = "http://192.168.1.16:1234/";

  static const DATABASE_USER = "userData";
}
