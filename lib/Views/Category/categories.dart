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
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  int selectedCategoryIndex = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10.h),
            _buildTitle(),
            SizedBox(height: 10.h),
            _buildCategorySelector(),
            SizedBox(height: 10.h),
            Expanded(child: _buildAnimatedContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      "Categories",
      style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildCategorySelector() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Container(
        height: 50.h,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: ListView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          children: [
            _buildCategoryButton("All", 0),
            _buildCategoryButton("Painting", 1),
            _buildCategoryButton("Cleaning", 2),
            _buildCategoryButton("Electric", 3),
            _buildCategoryButton("Carpenters", 4),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton(String text, int index) {
    bool isSelected = selectedCategoryIndex == index;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 30.h,
        width: 90.w,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.appColor : Colors.white,
          borderRadius: BorderRadius.circular(30.r),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                      color: AppColors.appColor.withOpacity(0.4),
                      blurRadius: 10)
                ]
              : [],
        ),
        child: TextButton(
          onPressed: () => _onCategorySelected(index),
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.appColor,
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedContent() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      child: _buildContent(selectedCategoryIndex),
    );
  }

  void _onCategorySelected(int index) {
    setState(() {
      selectedCategoryIndex = index;
    });
  }

  Widget _buildContent(int index) {
    switch (index) {
      case 1:
        return const PaintingServices();
      case 2:
        return const CleaningServices();
      case 3:
        return const ElectricServices();
      case 4:
        return const CarpentoryServices();
      default:
        return const AllServices();
    }
  }
}
