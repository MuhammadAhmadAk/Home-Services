import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:home_services/Utils/constants/colors.dart';

void AppLoading({required BuildContext context, required String? msg}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.white,
        child: SizedBox(
          height: 100.h,
          width: 100.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SpinKitFadingCircle(
                color: AppColors.appColor,
                size: 50.0,
              ),
              SizedBox(width: 20),
              Text(msg ?? "Loading..."),
            ],
          ),
        ),
      );
    },
  );
}
