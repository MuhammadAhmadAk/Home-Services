import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_services/Views/Category/Pages/all_services.dart';
import 'package:home_services/Views/Category/Pages/carpentory_pages.dart';
import 'package:home_services/Views/Category/Pages/cleaning_services_page.dart';
import 'package:home_services/Views/Category/Pages/electricians_page.dart';
import 'package:home_services/Views/Category/Pages/painting_page.dart';

import '../../Utils/Components/custom_button.dart';
import '../../Utils/constants/colors.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({
    super.key,
  });

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  int selectedCategoryIndex = 0; // Initialize with the index of 'All'

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 20.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Categories",
                  style:
                      TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w800),
                ),
              ],
            ),
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Container(
                height: 31.h,
                decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(10.r)),
                child: ListView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  children: [
                    CustomButtonWidget(
                      buttonHeight: 35.h,
                      buttonWidth: 100.w,
                      buttonBackgroundColor: (selectedCategoryIndex == 0)
                          ? AppColors.appColor
                          : Colors.white,
                      textColor: (selectedCategoryIndex == 0)
                          ? Colors.white
                          : AppColors.appColor,
                      text: "All",
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      onPressed: () {
                        changeScreen(0);
                      },
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    CustomButtonWidget(
                      buttonHeight: 35.h,
                      buttonWidth: 110.w,
                      buttonBackgroundColor: (selectedCategoryIndex == 1)
                          ? AppColors.appColor
                          : Colors.white,
                      textColor: (selectedCategoryIndex == 1)
                          ? Colors.white
                          : AppColors.appColor,
                      text: "Painting",
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      onPressed: () {
                        changeScreen(1);
                      },
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    CustomButtonWidget(
                      buttonHeight: 35.h,
                      buttonWidth: 110.w,
                      text: "Cleaning",
                      buttonBackgroundColor: (selectedCategoryIndex == 2)
                          ? AppColors.appColor
                          : Colors.white,
                      textColor: (selectedCategoryIndex == 2)
                          ? Colors.white
                          : AppColors.appColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      onPressed: () {
                        changeScreen(2);
                      },
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    CustomButtonWidget(
                      buttonHeight: 35.h,
                      buttonWidth: 110.w,
                      text: "Electric",
                      buttonBackgroundColor: (selectedCategoryIndex == 3)
                          ? AppColors.appColor
                          : Colors.white,
                      textColor: (selectedCategoryIndex == 3)
                          ? Colors.white
                          : AppColors.appColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      onPressed: () {
                        changeScreen(3);
                      },
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    GestureDetector(
                      onTap: () {
                        _scrollController.jumpTo(_scrollController.offset);
                      },
                      child: CustomButtonWidget(
                        buttonHeight: 35.h,
                        buttonWidth: 112.w,
                        text: "Carpentors",
                        buttonBackgroundColor: (selectedCategoryIndex == 4)
                            ? AppColors.appColor
                            : Colors.white,
                        textColor: (selectedCategoryIndex == 4)
                            ? Colors.white
                            : AppColors.appColor,
                        fontSize: 13.sp,
                        buttonElevation: 0,
                        fontWeight: FontWeight.w500,
                        onPressed: () {
                          changeScreen(4);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: _buildContent(selectedCategoryIndex),
            ),
          ],
        ),
      ),
    );
  }

  void changeScreen(int screenIndex) {
    setState(() {
      selectedCategoryIndex = screenIndex;
    });
  }

  Widget _buildContent(int selectedCategoryIndex) {
    if (selectedCategoryIndex == 0) {
      return const AllServices();
    } else if (selectedCategoryIndex == 1) {
      return const PaintingServices();
    } else if (selectedCategoryIndex == 2) {
      return const CleaningServices();
    } else if (selectedCategoryIndex == 3) {
      return const ElectricServices();
    } else if (selectedCategoryIndex == 4) {
      return const CarpentoryServices();
    } else {
      // Handle other indices or default to AllProductScreen.
      return const AllServices();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
