import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/colors.dart';

class PasswordTextField extends StatefulWidget {
  const PasswordTextField({
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
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool obxtext = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label ?? "",
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
                obscureText: obxtext,
                controller: widget.controller,
                keyboardType: widget.inputType,
                cursorColor: Colors.grey.withOpacity(0.4),
                decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          obxtext = !obxtext;
                        });
                      },
                      child: Icon(
                        obxtext ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                    ),
                    contentPadding: EdgeInsets.all(10.w),
                    hintText: widget.hintText,
                    fillColor: AppColors.greyColor.withOpacity(0.05),
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.r),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.r),
                      borderSide: BorderSide.none,
                    )),
              )),
        ],
      ),
    );
  }
}
