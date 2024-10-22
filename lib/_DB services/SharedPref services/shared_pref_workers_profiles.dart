import 'dart:convert';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefWorkerProfiles {
  static const String _workerProfilesKey = 'worker_profiles';

  // Static method to store the list of Map<String, dynamic>
  static Future<void> storeWorkerProfiles(
      List<Map<String, dynamic>> profiles) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Convert the list of maps to a JSON string
    String encodedProfiles = jsonEncode(profiles);

    // Store the JSON string in shared preferences
    await prefs.setString(_workerProfilesKey, encodedProfiles);
    log("save to shared preferences $encodedProfiles");
  }

  // Static method to retrieve the list of Map<String, dynamic>
  static Future<List<Map<String, dynamic>>> getWorkerProfiles() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the JSON string from shared preferences
    String? encodedProfiles = prefs.getString(_workerProfilesKey);

    if (encodedProfiles == null) {
      return [];
    }

    // Decode the JSON string back to a list of maps
    List<dynamic> decodedList = jsonDecode(encodedProfiles);

    // Cast each element in the list to Map<String, dynamic>
    List<Map<String, dynamic>> profiles =
        decodedList.cast<Map<String, dynamic>>();

    return profiles;
  }

  // Optional: Static method to clear stored profiles
  static Future<void> clearWorkerProfiles() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_workerProfilesKey);
  }
}
