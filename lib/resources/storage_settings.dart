import 'dart:convert';

import 'package:cosmocloset/model/userSettings.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SettingsService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<UserSettings> loadUserSettings(String userId) async {
    String? settingsString = await _storage.read(key: userId);
    if (settingsString != null) {
      Map<String, dynamic> settingsMap = jsonDecode(settingsString);
      return UserSettings.fromMap(settingsMap);
    } else {
      // Return default settings for a new user
      return UserSettings();
    }
  }

  Future<void> saveUserSettings(String userId, UserSettings settings) async {
    String settingsString = jsonEncode(settings.toMap());
    await _storage.write(key: userId, value: settingsString);
  }
}