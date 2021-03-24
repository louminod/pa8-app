import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:pa8/models/Analyse.dart';
import 'package:pa8/models/User.dart';
import 'package:pa8/models/references/MoleType.dart';
import 'package:pa8/utils/constants.dart';

abstract class ApiService {
  static Future<dynamic> get() async {
    final response = await http.get(Uri.parse(Constants.API_URL));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Get request failed');
    }
  }

  static Future<Analyse> makeAnalyseOfImage(UserData user, File image) async {
    try {
      dynamic body = {
        "image": (await image.readAsBytes()).toString(),
      };

      final response = await http.post(Uri.parse(Constants.API_URL + "analyse"), body: body);
      dynamic data;
      if (response.statusCode == 200) {
        data = json.decode(response.body)["data"];
      } else {
        throw Exception('Get request failed');
      }

      Analyse analyse = new Analyse();
      analyse.risk = data["risk"];
      switch (data["type"].toString().toUpperCase()) {
        case "BENIGN":
          analyse.moleType = MoleType.BENIGN;
          break;
        case "MALIGNANT":
          analyse.moleType = MoleType.MALIGNANT;
          break;
        case "UNKNOWN":
          analyse.moleType = MoleType.UNKNOWN;
          break;
        default:
          analyse.moleType = MoleType.UNKNOWN;
          break;
      }
      analyse.moleType = MoleType.BENIGN;
      analyse.date = DateTime.now();
      analyse.imageUrl = image.path;

      return analyse;
    } catch (error) {
      print("ERROR -> makeAnalyseOfImage -> ${error.toString()}");
      return null;
    }
  }
}
