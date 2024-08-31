class UserModel {
  String userId; // User ID
  String name;
  String email;
  String phone;
  String password;
  String userType; // Represent user type as a string
  String? profilePic; // URL of the profile picture

  UserModel({
    required this.userId, // Include userId in the constructor
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.userType,
    this.profilePic, // Nullable field for profile picture URL
  });

  // Method to convert UserModel instance to a map
  Map<String, dynamic> toMap() {
    return {
      'userId': userId, // Include userId in the map
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'userType': userType,
      'profilePic': profilePic, // Include profilePic in the map
    };
  }

  // Method to create UserModel instance from a map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId'] ?? '', // Retrieve userId from the map
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      password: map['password'] ?? '',
      userType: map['userType'] ?? '',
      profilePic: map['profilePic'], // Retrieve profilePic from the map
    );
  }
}
