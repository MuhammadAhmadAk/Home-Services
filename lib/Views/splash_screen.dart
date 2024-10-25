import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:home_services/Utils/constants/assets.dart';
import 'package:home_services/Utils/constants/colors.dart';
import 'package:home_services/Views/bottom_navbar.dart';
import 'package:home_services/Views/onboarding_screen.dart';

import '../_DB services/SharedPref services/sharedpref_auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigatetoScreen();
  }

  void navigatetoScreen() async {
    // Check the login status
    bool isLoggedIn = await SharedPrefAuth.getLoginStatus();
    String? userid = await SharedPrefAuth.getUserId();

    Future.delayed(Duration(seconds: 3), () {
      if (isLoggedIn) {
        // If logged in, navigate to HomeScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                CustomNavbar(), // Replace with your home screen
          ),
        );
      } else {
        // If not logged in, navigate to OnBoardingScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OnBoardingScreen(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                Image.asset(
                  ImgAssets.splash2,
                  height: 230.h,
                ),
                SizedBox(
                  height: 30.h,
                ),
                Text(
                  "Home Services",
                  style: TextStyle(
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.whiteColor),
                ),
                SpinKitFadingFour(
                  color: Colors.white,
                  size: 50.0,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
