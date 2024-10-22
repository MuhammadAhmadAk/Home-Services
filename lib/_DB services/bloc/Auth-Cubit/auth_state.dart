import 'package:home_services/models/user_model.dart';

class AuthState {}

final class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthProfileFetchingState extends AuthState {}

class AuthUserProfileFetchState extends AuthState {
  final UserModel user;
  AuthUserProfileFetchState({required this.user});
}

class AuthRegisteredState extends AuthState {
  final UserModel user;

  AuthRegisteredState({required this.user});
}

class AuthLoggedInState extends AuthState {
  final UserModel user;

  AuthLoggedInState({required this.user});
}

class GetuserbyIdState extends AuthState {
  final UserModel user;

  GetuserbyIdState({required this.user});
}

class AuthProfileUploadedState extends AuthState {
  final String profilePicUrl;
  AuthProfileUploadedState(this.profilePicUrl);
}

class AuthErrorState extends AuthState {
  final String error;

  AuthErrorState({required this.error});
}
