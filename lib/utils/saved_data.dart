import 'package:shared_preferences/shared_preferences.dart';

class SavedData {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Save user name
  static Future<void> saveUserName(String name) async {
    await _prefs?.setString('name', name);
  }

  // Get user name
  static String getUserName() {
    return _prefs?.getString('name') ?? 'User';
  }

  // Save user email
  static Future<void> saveUserEmail(String email) async {
    await _prefs?.setString('email', email);
  }

  // Get user email
  static String getUserEmail() {
    return _prefs?.getString('email') ?? '';
  }

  // Save user ID
  static Future<void> saveUserId(String id) async {
    await _prefs?.setString('userId', id);
  }

  // Get user ID
  static String getUserId() {
    return _prefs?.getString('userId') ?? '';
  }

  // Save user organizer status
  static Future<void> saveUserIsOrganized(bool isOrganized) async {
    await _prefs?.setBool('isOrganized', isOrganized);
  }

  // Get user organizer status
  static bool getUserIsOrganized() {
    return _prefs?.getBool('isOrganized') ?? false;
  }

  // Clear all saved data
  static Future<void> clearSavedData() async {
    await _prefs?.clear();
  }
}
