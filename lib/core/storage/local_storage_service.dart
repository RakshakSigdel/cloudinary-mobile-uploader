import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  Future<SharedPreferences> get _prefs async => SharedPreferences.getInstance();

  Future<void> setString(String key, String value) async {
    final prefs = await _prefs;
    await prefs.setString(key, value);
  }

  Future<String?> getString(String key) async {
    final prefs = await _prefs;
    return prefs.getString(key);
  }

  Future<void> setJson(String key, Map<String, dynamic> value) async {
    await setString(key, jsonEncode(value));
  }

  Future<Map<String, dynamic>?> getJson(String key) async {
    final raw = await getString(key);
    if (raw == null) return null;
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  Future<void> setJsonList(String key, List<Map<String, dynamic>> value) async {
    await setString(key, jsonEncode(value));
  }

  Future<List<Map<String, dynamic>>> getJsonList(String key) async {
    final raw = await getString(key);
    if (raw == null) return [];
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded.cast<Map<String, dynamic>>();
  }

  Future<void> remove(String key) async {
    final prefs = await _prefs;
    await prefs.remove(key);
  }
}
