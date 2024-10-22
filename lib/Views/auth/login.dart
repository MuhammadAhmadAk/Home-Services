import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_services/Utils/Components/custom_button.dart';
import 'package:home_services/Utils/Components/custom_snakbar.dart';
import 'package:home_services/Utils/Components/custom_textfield.dart';
import 'package:home_services/Utils/constants/assets.dart';
import 'package:home_services/Views/auth/register.dart';
import 'package:home_services/Views/bottom_navbar.dart';
import 'package:home_services/_DB%20services/SharedPref%20services/sharedpref_auth.dart';
import 'package:home_services/_DB%20services/bloc/Auth-Cubit/auth_cubit.dart';
import 'package:home_services/_DB%20services/bloc/Auth-Cubit/auth_state.dart';
import '../../Utils/Components/app_loader.dart';
import '../../Utils/Components/password_filed.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLoggedInState) {
          String userid = FirebaseAuth.instance.currentUser!.uid;
          showMessage(context, "Success", "Login Successful");
          SharedPrefAuth.setLoginStatus(true);
          SharedPrefAuth.setUserId(userid);
          SharedPrefAuth.saveUser(state.user);
          Navigator.pushReplacement(
            context,
            CupertinoPageRoute(
              builder: (context) => CustomNavbar(),
            ),
          );
        } else if (state is AuthLoadingState) {
          AppLoading(context: context, msg: "Logging in...");
        } else if (state is AuthErrorState) {
          Navigator.pop(context);
          showMessage(context, "Error", state.error.toString());
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Image.asset(ImgAssets.loginImg),
                    Positioned(
                      top: 280.h,
                      left: 150.w,
                      child: Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 35.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                CustomTextField(
                  controller: emailController,
                  inputType: TextInputType.emailAddress,
                  hintText: "Email",
                ),
                PasswordTextField(
                  controller: passwordController,
                  hintText: "Password",
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "Forgot Password",
                        style: TextStyle(fontSize: 13.sp),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                CustomButtonWidget(
                  text: "Login",
                  onPressed: () async {
                    if (emailController.text.isEmpty ||
                        passwordController.text.isEmpty) {
                      showMessage(
                          context, "Error", "Please fill in all fields");
                    } else {
                      await context.read<AuthCubit>().loginUser(
                            emailController.text.trim(),
                            passwordController.text,
                          );
                    }
                  },
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(fontSize: 13.sp),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => const RegisterScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Create Account",
                        style: TextStyle(fontSize: 13.sp),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
