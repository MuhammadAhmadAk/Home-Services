import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefProducts {
  static const String _ProductsKey = 'products';

  // Static method to store the list of Map<String, dynamic>
  static Future<void> storeProducts(
      List<Map<String, dynamic>> products) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Convert the list of maps to a JSON string
    String encodedproducts = jsonEncode(products);

    // Store the JSON string in shared preferences
    await prefs.setString(_ProductsKey, encodedproducts);
    // log("save to shared preferences $encodedproducts");
  }

  // Static method to retrieve the list of Map<String, dynamic>
  static Future<List<Map<String, dynamic>>> getProducts() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the JSON string from shared preferences
    String? encodedproducts = prefs.getString(_ProductsKey);

    if (encodedproducts == null) {
      return [];
    }

    // Decode the JSON string back to a list of maps
    List<dynamic> decodedList = jsonDecode(encodedproducts);

    // Cast each element in the list to Map<String, dynamic>
    List<Map<String, dynamic>> products =
        decodedList.cast<Map<String, dynamic>>();

    return products;
  }

  // Optional: Static method to clear stored profiles
  static Future<void> clearProductsing() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_ProductsKey);
  }
}
