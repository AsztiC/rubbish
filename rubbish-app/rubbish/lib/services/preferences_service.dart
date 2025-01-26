import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  Future<void> saveBooleans(List<bool> booleans) async {
    final prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < booleans.length; i++) {
      prefs.setBool('boolean_$i', booleans[i]);
    }
  }

  Future<List<bool>> loadBooleans() async {
    final prefs = await SharedPreferences.getInstance();
    List<bool> booleans = [];
    for (int i = 0; i < 8; i++) {
      bool value = prefs.getBool('boolean_$i') ?? false;
      booleans.add(value);
    }
    return booleans;
  }

  Future<void> saveIntegers(List<int> integers) async {
    final prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < integers.length; i++) {
      prefs.setInt('integer_$i', integers[i]);
    }
  }

  Future<List<int>> loadIntegers() async {
    final prefs = await SharedPreferences.getInstance();
    List<int> integers = [];
    for (int i = 0; i < 8; i++) {
      int value = prefs.getInt('integer_$i') ?? 0;
      integers.add(value);
    }
    return integers;
  }
}
