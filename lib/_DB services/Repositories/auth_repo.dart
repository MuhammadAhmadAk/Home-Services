import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:home_services/models/user_model.dart';

class AuthRepo {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel> registerUser(String name, String email, String phone,
      String password, String userType) async {
    try {
      // Check if the user already exists

      // Create a new user with email and password
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the newly created user
      User? user = userCredential.user;

      // Create a UserModel instance
      UserModel newUser = UserModel(
          userId: user!.uid,
          name: name,
          email: email,
          phone: phone,
          password: password,
          userType: userType,
          isWoker: false);

      // Save user details to Firestore
      await _firestore.collection('users').doc(user.uid).set(newUser.toMap());

      return newUser;
    } catch (e) {
      // Rethrow any exceptions to be handled by the caller
      rethrow;
    }
  }

  Future<UserModel> loginUser(String email, String password) async {
    try {
      // Sign in with email and password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      // Check if the user is not null
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user!.uid).get();

      if (!userDoc.exists) {
        throw Exception('User data not found in Firestore');
      }
      print(userDoc.data());
      UserModel loggedInUser =
          UserModel.fromMap(userDoc.data() as Map<String, dynamic>);

      return loggedInUser;
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException: ${e.message}');
      throw Exception('Failed to login: ${e.message}');
    } catch (e) {
      print('Error during login: $e');
      rethrow;
    }
  }

  Future<UserModel> getUserById(String userId) async {
    try {
      // Get the document snapshot for the user with the specified userId
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();

      // Check if the document exists
      if (!userDoc.exists) {
        throw Exception('User with ID $userId not found in Firestore');
      }

      // Convert the data from Firestore to a UserModel object
      UserModel user =
          UserModel.fromMap(userDoc.data() as Map<String, dynamic>);

      return user;
    } catch (e) {
      // Rethrow any exceptions to be handled by the caller
      rethrow;
    }
  }

  Future<String> updateUserProfile(String userId, String profilePicUrl) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'profilePic': profilePicUrl,
      });
      return profilePicUrl;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateIsWorkerStatus(String userId, bool isWorker) async {
    try {
      // Update the isWorker status in the Firestore document for the given user
      await _firestore.collection('users').doc(userId).update({
        'isWoker': isWorker,
      });
    } catch (e) {
      // Rethrow any exceptions to be handled by the caller
      rethrow;
    }
  }
}
