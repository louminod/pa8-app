import 'package:flutter/services.dart';

abstract class Constants {
  static const List<DeviceOrientation> ORIENTATIONS_ALLOWED = [
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ];

  static const API_URL = "localhost:5000";

  static const DATABASE_USER = "userData";
}
