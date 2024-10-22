import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class SharedprefWokerBookings {
  static const String _WorkerBookKey = 'bookings';

  // Static method to store the list of Map<String, dynamic>
  static Future<void> storeWorkerBooking(
      List<Map<String, dynamic>> bookings) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Convert the list of maps to a JSON string
    String encodedbookings = jsonEncode(bookings);

    // Store the JSON string in shared preferences
    await prefs.setString(_WorkerBookKey, encodedbookings);
   // log("save to shared preferences $encodedbookings");
  }

  // Static method to retrieve the list of Map<String, dynamic>
  static Future<List<Map<String, dynamic>>> getWorkerBooking() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the JSON string from shared preferences
    String? encodedbookings = prefs.getString(_WorkerBookKey);

    if (encodedbookings == null) {
      return [];
    }

    // Decode the JSON string back to a list of maps
    List<dynamic> decodedList = jsonDecode(encodedbookings);

    // Cast each element in the list to Map<String, dynamic>
    List<Map<String, dynamic>> bookings =
        decodedList.cast<Map<String, dynamic>>();

    return bookings;
  }

  // Optional: Static method to clear stored profiles
  static Future<void> clearWorkerBooking() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_WorkerBookKey);
  }
}
