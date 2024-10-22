import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user_model.dart';

class SharedPrefAuth {
  static const String _keyIsLoggedIn = 'isLoggedIn';
  static const String _keyToken = 'token';
  static const String _keyUserId = 'userId';
  static const String _keyUserModel = 'userModel';
  // Save UserModel
  static Future<void> saveUser(UserModel user) async {
    final prefs = await _prefs();

    // Convert UserModel to Map, then encode the Map as a JSON string and save it
    String userJson = jsonEncode(user.toMap());
    await prefs.setString(_keyUserModel, userJson);
    log("User saved: $userJson");
  }

  // Get UserModel
  static Future<UserModel?> getUser() async {
    final prefs = await _prefs();

    // Retrieve the stored JSON string
    String? userJson = prefs.getString(_keyUserModel);

    if (userJson == null) {
      
      return null; // No user data found
    }

    // Convert JSON string back to Map and then to UserModel object
    Map<String, dynamic> userMap = jsonDecode(userJson);
    return UserModel.fromMap(userMap);
  }

  // Initialize SharedPreferences
  static Future<SharedPreferences> _prefs() async {
    return await SharedPreferences.getInstance();
  }

  // Save login status
  static Future<void> setLoginStatus(bool isLoggedIn) async {
    final prefs = await _prefs();
    await prefs.setBool(_keyIsLoggedIn, isLoggedIn);
    log("login status set to " + _keyIsLoggedIn);
  }

  // Get login status
  static Future<bool> getLoginStatus() async {
    final prefs = await _prefs();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  // Save authentication token
  static Future<void> setToken(String token) async {
    final prefs = await _prefs();
    await prefs.setString(_keyToken, token);
  }

  // Get authentication token
  static Future<String?> getToken() async {
    final prefs = await _prefs();
    return prefs.getString(_keyToken);
  }

  // Save user ID
  static Future<void> setUserId(String userId) async {
    final prefs = await _prefs();
    await prefs.setString(_keyUserId, userId);
    log("user ID set to " + _keyUserId);
  }

  // Get user ID
  static Future<String?> getUserId() async {
    final prefs = await _prefs();
    return prefs.getString(_keyUserId);
  }

  // Clear all authentication data (logout)
  static Future<void> clearAuthData() async {
    final prefs = await _prefs();
    await prefs.remove(_keyIsLoggedIn);
    await prefs.remove(_keyToken);
    await prefs.remove(_keyUserId);
  }
}
