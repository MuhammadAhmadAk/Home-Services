import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/colors.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.label,
    this.controller,
    this.inputType,
    this.hintText,
    this.labelTheme,
  });
  final String? label;
  final TextEditingController? controller;
  final TextInputType? inputType;
  final String? hintText;
  final TextStyle? labelTheme;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label ?? "",
            style: TextStyle(fontSize: 12.sp),
          ),
          SizedBox(
            height: 7.h,
          ),
          Container(
              width: 330.w,
              height: 50.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.r),
              ),
              child: TextField(
                controller: controller,
                keyboardType: inputType,
                cursorColor: Colors.grey.withOpacity(0.4),
                style: TextStyle(fontWeight: FontWeight.w100),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.w),
                    hintText: hintText,
                    fillColor: AppColors.greyColor.withOpacity(0.05),
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.r),
                        borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.r),
                        borderSide: BorderSide.none)),
              )),
        ],
      ),
    );
  }
}
