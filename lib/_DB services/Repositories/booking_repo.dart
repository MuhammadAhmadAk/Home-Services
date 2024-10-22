import 'dart:developer' as dev;
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookingRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to create a hire booking
  Future<void> createHireBook({
    required String fullName,
    required String contactNumber,
    required String email,
    required String workType,
    required String address,
    required String startTime,
    required String endTime,
    required Map<String, dynamic> locations,
    required String paymentMethod,
    required Map<String, dynamic>
        worker, // Optional: location ID for a single-location booking
  }) async {
    try {
      String workerId = FirebaseAuth.instance.currentUser!.uid;

      // Create a new booking document
      DocumentReference docRef = await _firestore.collection('bookings').add({
        "wokerId": workerId,
        "hiredWorkerId": worker["workerId"],
        'full_name': fullName,
        'contact_number': contactNumber,
        'email': email,
        'work_type': workType,
        'address': address,
        'start_time': startTime,
        'end_time': endTime,
        'locations': locations, // Map of location IDs to their coordinates
        'payment_method': paymentMethod,
        'createdAt': DateTime.timestamp().toString(),
        'worker': worker, // Optional: worker information if available
        "isAvailable": false
      });
      docRef.update({"bookingId": docRef.id});
    } catch (e) {
      print("Error creating booking: $e");
      throw e; // Propagate the error if needed
    }
  }

  Future<List<Map<String, dynamic>>> getBookings() async {
    try {
      String userid = FirebaseAuth.instance.currentUser!.uid;

      // Fetch bookings where 'workerId' matches the current user's ID
      QuerySnapshot querySnapshot = await _firestore
          .collection('bookings')
          .where(FieldPath.fromString('wokerId'), isEqualTo: userid)
          .get();

      // Convert query results to a list of maps
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print("Error fetching bookings: $e");
      rethrow; // Propagate the error if needed
    }
  }

  Future<List<Map<String, dynamic>>> getWorkerBookings(String workerID) async {
    try {
      // Fetch bookings where 'workerId' matches the current user's ID
      QuerySnapshot querySnapshot = await _firestore
          .collection('bookings')
          .where(FieldPath.fromString('hiredWorkerId'), isEqualTo: workerID)
          .get();

      // Convert query results to a list of maps
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print("Error fetching bookings: $e");
      rethrow; // Propagate the error if needed
    }
  }

  Future<void> updateAvailabilityStatus({
    required String bookingId,
    required bool isAvailable,
  }) async {
    try {
      dev.log("Availability status updating.");
      // Update the availability status of the specified booking
      await _firestore.collection('bookings').doc(bookingId).update({
        'isAvailable': isAvailable,
      });
      dev.log("Availability status updated successfully.");
    } catch (e) {
      print("Error updating availability status: $e");
      throw e;
    }
  }
}
