import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';

class OrderRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to create a new order in Firestore
  Future<void> createOrder({
    required String orderId,
    required String userId,
    required String productId,
    required int quantity,
    required double price,
    required String shippingAddress,
    required String paymentMethod,
    required String status,
    required DateTime orderDate,
  }) async {
    try {
      // Creating order data to store in Firestore
      Map<String, dynamic> orderData = {
        'orderId': orderId,
        'userId': userId,
        'productId': productId,
        'quantity': quantity,
        'price': price,
        'shippingAddress': shippingAddress,
        'paymentMethod': paymentMethod,
        'status': status,
        'orderDate': orderDate.toIso8601String(),
      };

      // Storing the order in Firestore under 'orders' collection
      await _firestore.collection('orders').doc(orderId).set(orderData);

      log("Order created successfully: $orderId");
    } catch (e) {
      log("Failed to create order: $e");
      throw e; // Re-throw error for further handling if necessary
    }
  }

  // Function to get all orders for a specific user
  Future<List<Map<String, dynamic>>> getAllOrdersForUser(String userId) async {
    try {
      // Fetching orders where userId matches
      QuerySnapshot querySnapshot = await _firestore
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .get();

      // Mapping the query results to a list of order maps
      List<Map<String, dynamic>> orders = querySnapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();

      log("Fetched ${orders.length} orders for user: $userId");
      return orders;
    } catch (e) {
      log("Failed to fetch orders for user $userId: $e");
      throw e; // Re-throw error for further handling if necessary
    }
  }
}
