abstract class Formater {
  static String formatDateTime(DateTime dateTime) {
    return "${dateTime.toString().split(" ")[0]} ${dateTime.toString().split(" ")[1].split(":")[0]}h${dateTime.toString().split(" ")[1].split(":")[1]}";
  }
}