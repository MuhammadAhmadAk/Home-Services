import 'package:cloud_firestore/cloud_firestore.dart';

class ProductRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<List<Map<String, dynamic>>> fetchedProducts() async {
    try {
      // Fetch bookings where 'workerId' matches the current user's ID
      QuerySnapshot querySnapshot =
          await _firestore.collection('products').get();
      // Convert query results to a list of maps
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
