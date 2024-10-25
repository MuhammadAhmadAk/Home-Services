import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_services/Utils/Components/app_loader.dart';
import 'package:home_services/Utils/Components/custom_button.dart';
import 'package:home_services/Utils/Components/custom_snakbar.dart';
import 'package:home_services/Utils/Components/custom_textfield.dart';
import 'package:home_services/Utils/constants/assets.dart';
import 'package:home_services/Views/auth/login.dart';
import 'package:home_services/Views/auth/upload_profile.dart';
import 'package:home_services/_DB%20services/bloc/Auth-Cubit/auth_cubit.dart';
import 'package:home_services/_DB%20services/bloc/Auth-Cubit/auth_state.dart';

import '../../Utils/Components/password_filed.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  int selectedValue = 0;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void clearController() {
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        String userid = FirebaseAuth.instance.currentUser!.uid;
        if (state is AuthRegisteredState) {
          showMessage(context, "Success", "Registered Successfull");
          Navigator.pop(context);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => UploadProfile(
                  userId: state.user.userId,
                ),
              ));
          clearController();
        } else if (state is AuthLoadingState) {
          AppLoading(context: context, msg: "Registering...");
        } else if (state is AuthErrorState) {
          showMessage(context, "Error", state.error.toString());
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(
                  ImgAssets.signUpImg,
                  height: 250.h,
                ), // Image as the background
                Text(
                  "Register",
                  style: TextStyle(
                      fontSize: 35.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w700), // Add color property
                ),
                CustomTextField(
                  controller: nameController,
                  hintText: "Name",
                ),
                CustomTextField(
                  controller: emailController,
                  inputType: TextInputType.emailAddress,
                  hintText: "Email",
                ),
                CustomTextField(
                  controller: phoneController,
                  inputType: TextInputType.number,
                  hintText: "Phone",
                ),
                PasswordTextField(
                  controller: passwordController,
                  hintText: "Password",
                ),
                SizedBox(
                  height: 20.h,
                ),
                CustomButtonWidget(
                    text: "Register",
                    onPressed: () async {
                      if (nameController.text.isEmpty ||
                          emailController.text.isEmpty ||
                          phoneController.text.isEmpty ||
                          passwordController.text.isEmpty) {
                        showMessage(context, "Error", "Please the all Fields");
                      } else {
                        await context.read<AuthCubit>().registerUser(
                            nameController.text,
                            emailController.text,
                            phoneController.text,
                            passwordController.text,
                            "User");
                      }
                    }),
                SizedBox(
                  height: 20.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "already have a account?",
                      style: TextStyle(fontSize: 13.sp),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ));
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(fontSize: 13.sp),
                        )),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
