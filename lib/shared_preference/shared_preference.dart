import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static late final SharedPreferences prefs;

  static Future init() async => prefs = await SharedPreferences.getInstance();
// set AuthToken once user login completed
  static Future<bool> setTitle(List<String> videosList) async {
    prefs.setStringList("title", videosList);

    return true;
  }

  static Future<bool> setDescription(List<String> videosList) async {
    prefs.setStringList("description", videosList);

    return true;
  }

  static List<String>? getTitle() => prefs.getStringList("title");
  static List<String>? getDescription() => prefs.getStringList("description");
}
