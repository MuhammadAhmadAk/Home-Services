import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_services/Repositories/auth_repo.dart';
import 'package:home_services/bloc/Auth-Cubit/auth_state.dart';
import 'package:home_services/models/user_model.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitialState());

  AuthRepo authRepo = AuthRepo();

  Future<void> registerUser(String name, String email, String phone,
      String password, String userType) async {
    emit(AuthLoadingState());
    try {
      UserModel user =
          await authRepo.registerUser(name, email, phone, password, userType);
      emit(AuthRegisteredState(user: user));
    } catch (e) {
      print(e.toString());
      emit(AuthErrorState(error: e.toString()));
    }
  }

  Future<void> loginUser(String email, String password) async {
    emit(AuthLoadingState());
    try {
      var user = await authRepo.loginUser(email, password);
      print(user.name);
      emit(AuthLoggedInState(user: user));
    } catch (e) {
      print("loginError:${e.toString()}");
      emit(AuthErrorState(error: e.toString()));
    }
  }

  Future<void> updateProfilePic(String profilePic) async {
    emit(AuthLoadingState());
    try {
      User? user = FirebaseAuth.instance.currentUser;
      String url = await authRepo.updateUserProfile(user!.uid, profilePic);
      emit(AuthProfileUploadedState(url));
    } catch (e) {
      emit(AuthErrorState(error: e.toString()));
    }
  }
}
