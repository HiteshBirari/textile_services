

import 'package:shared_preferences/shared_preferences.dart';

class PrefUtils {
  late SharedPreferences _sharedPreferences;

  PrefUtils() {
    SharedPreferences.getInstance().then((value) {
      _sharedPreferences = value;
    });
  }

  void clearPreferencesData() async {
    await _sharedPreferences.clear();
  }

  Future<void> setRole(String value) {
    return _sharedPreferences.setString('role', value);
  }

  String getRole() {
    try {
      return _sharedPreferences.getString('role') ?? "";
    } catch (e) {
      return "";
    }
  }

  Future<void> setName(String value) {
    return _sharedPreferences.setString('name', value);
  }

  String getName() {
    try {
      return _sharedPreferences.getString('name') ?? "";
    } catch (e) {
      return "";
    }
  }

  Future<void> setWorkerID(String value) {
    return _sharedPreferences.setString('Id', value);
  }

  String getWorkerID() {
    try {
      return _sharedPreferences.getString('Id') ?? "";
    } catch (e) {
      return "";
    }
  }
}