import 'package:pa8/models/references/MoleType.dart';
import 'package:pa8/models/references/UserType.dart';

abstract class Converter {
  static UserType stringToUserType(String string) {
    UserType result;
    for (UserType userType in UserType.values) {
      if (userType.toString() == string) {
        result = userType;
      }
    }
    return result;
  }

  static MoleType stringToMoleType(String string) {
    MoleType result;
    for (MoleType moleType in MoleType.values) {
      if (moleType.toString() == string) {
        result = moleType;
      }
    }
    return result;
  }
}
