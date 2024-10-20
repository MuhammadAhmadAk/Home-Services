import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WorkerProfilesRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Collection reference for worker profiles
  CollectionReference get _workerProfilesCollection =>
      _firestore.collection('worker_profiles');

  // Function to create a new worker profile for the current user
  Future<Map<String, dynamic>?> createWorkerProfile({
    required String name,
    required String category,
    required String contactInfo,
    required String address,
    required String experience,
    required String bio,
    required String profilePic,
  }) async {
    try {
      // Get the current logged-in user
      User? currentUser = _auth.currentUser;

      if (currentUser == null) {
        print('No user is logged in');
        return null;
      }

      String workerId =
          currentUser.uid; // Use the current user's UID as the worker ID

      Map<String, dynamic> workerData = {
        'workerId': workerId,
        'name': name,
        'category': category,
        'contactInfo': contactInfo,
        'address': address,
        'experience': experience,
        'bio': bio,
        'profilePic': profilePic,
        'createdAt': DateTime.timestamp().toString(),
      };

      // Save worker profile to Firestore
      await _workerProfilesCollection.doc(workerId).set(workerData);

      // Return the created worker profile data
      print('Worker profile created successfully for current user');
      return workerData;
    } catch (e) {
      print('Failed to create worker profile: $e');
      rethrow;
    }
  }

  // Function to update an existing worker profile for the current user
  Future<Map<String, dynamic>?> updateWorkerProfile({
    String? name,
    String? category,
    String? contactInfo,
    String? address,
    String? experience,
    String? bio,
  }) async {
    try {
      // Get the current logged-in user
      User? currentUser = _auth.currentUser;

      if (currentUser == null) {
        print('No user is logged in');
        return null;
      }

      String workerId =
          currentUser.uid; // Use the current user's UID as the worker ID

      Map<String, dynamic> updatedData = {};

      // Add only non-null fields to the update map
      if (name != null) updatedData['name'] = name;
      if (category != null) updatedData['category'] = category;
      if (contactInfo != null) updatedData['contactInfo'] = contactInfo;
      if (address != null) updatedData['address'] = address;
      if (experience != null) updatedData['experience'] = experience;
      if (bio != null) updatedData['bio'] = bio;

      // Update worker profile in Firestore
      await _workerProfilesCollection.doc(workerId).update(updatedData);

      // Fetch the updated profile data after the update
      DocumentSnapshot docSnapshot =
          await _workerProfilesCollection.doc(workerId).get();
      Map<String, dynamic> updatedProfileData =
          docSnapshot.data() as Map<String, dynamic>;

      print('Worker profile updated successfully for current user');
      return updatedProfileData;
    } catch (e) {
      print('Failed to update worker profile: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getWorkerById(String workerId) async {
    try {
      // Fetch the document for the given worker ID
      DocumentSnapshot docSnapshot =
          await _workerProfilesCollection.doc(workerId).get();

      if (docSnapshot.exists) {
        // Convert document data to a map and return it
        Map<String, dynamic> workerData =
            docSnapshot.data() as Map<String, dynamic>;
        print('Worker profile found: $workerData');
        return workerData;
      } else {
        print('No worker profile found with ID: $workerId');
        return null;
      }
    } catch (e) {
      print('Failed to fetch worker profile: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getAllWorkersExceptCurrentUser() async {
    try {
      User? currentUser = _auth.currentUser;

      if (currentUser == null) {
        throw Exception('No user is logged in');
      }

      String currentUserId = currentUser.uid;

      // Query to get all worker profiles except the current logged-in user's profile
      QuerySnapshot querySnapshot = await _workerProfilesCollection
          .where('workerId', isNotEqualTo: currentUserId)
          .get();

      // Convert query result into a list of maps
      List<Map<String, dynamic>> workers = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      print('All worker profiles (except current user) fetched successfully');
      return workers;
    } catch (e) {
      print('Failed to fetch worker profiles: $e');
      rethrow;
    }
  }
}
