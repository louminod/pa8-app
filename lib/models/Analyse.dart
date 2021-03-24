import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pa8/models/references/MoleType.dart';
import 'package:pa8/tools/converter.dart';

class Analyse {
  String uid;
  String imageUrl;
  DateTime date;
  MoleType moleType;
  int risk;
  String title;
  String description;

  Analyse({this.uid, this.imageUrl, this.date, this.moleType, this.risk,this.title,this.description});

  Analyse.fromFireStoreCollection(String uid, Map<String, dynamic> parsedJson) {
    try {
      this.uid = uid;
      this.imageUrl = parsedJson["imageUrl"];
      this.date = (parsedJson["date"] as Timestamp).toDate();
      this.moleType = Converter.stringToMoleType(parsedJson["moleType"]);
      this.risk = parsedJson["risk"];
      this.title = parsedJson["title"];
      this.description = parsedJson["description"];
    } catch (error) {
      print("Error -> Analyse.fromFireStoreCollection -> " + error.toString());
    }
  }

  Analyse.fromJson(Map<String, dynamic> parsedJson) {
    try {
      this.uid = parsedJson["uid"];
      this.imageUrl = parsedJson["imageUrl"];
      this.date = DateTime.parse(parsedJson["date"]);
      this.moleType = Converter.stringToMoleType(parsedJson["moleType"]);
      this.risk = parsedJson["risk"];
      this.title = parsedJson["title"];
      this.description = parsedJson["description"];
    } catch (error) {
      print("Error -> Analyse.fromJson -> " + error.toString());
    }
  }

  Map<String, dynamic> toJson() => {
        'uid': this.uid,
        'imageUrl': this.imageUrl,
        'date': this.date.toString(),
        'moleType': this.moleType.toString(),
        'risk': this.risk,
        'title': this.title,
        'description': this.description,
      };
}
