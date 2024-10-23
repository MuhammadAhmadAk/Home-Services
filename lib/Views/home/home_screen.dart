import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_services/Utils/Components/service_widget.dart';
import 'package:home_services/Utils/constants/assets.dart';
import 'package:home_services/Utils/constants/colors.dart';
import 'package:home_services/Views/Category/categories.dart';
import 'package:home_services/Views/home/cat_widget.dart';
import 'package:home_services/_DB%20services/SharedPref%20services/shared_pref_workers_profiles.dart';
import 'package:home_services/_DB%20services/bloc/worker-cubit/wokers_profile_cubit.dart';
import 'package:home_services/_DB%20services/bloc/worker-cubit/wokers_profile_state.dart';
import 'package:home_services/models/user_model.dart';

import '../../Utils/Components/custom_drawer.dart';
import '../Category/Pages/detailspage.dart';
import 'papular_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.user});
  final UserModel user;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> AllProfiles = [];

  late PageController _pageController;
  late Timer _timer;
  List imageList = [];
  int _currentPage = 0;

  @override
  void initState() {
    imageList = [
      "assets/images/b1.jpg",
      "assets/images/b2.jpg",
      "assets/images/b3.jpg",
    ];
    super.initState();
    _pageController = PageController(initialPage: 0);
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentPage < popularServices.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    });
  }

  List<Widget> get popularServices {
    return imageList.map((imagePath) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Container(
          height: 50.h,
          width: 330.w,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
                filterQuality: FilterQuality.medium),
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
      );
    }).toList();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      drawer: CustomDrawer(
        user: widget.user,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          // Wrap the entire body in SingleChildScrollView
          child: Padding(
            padding: EdgeInsets.all(10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment
                  .start, // Ensure everything is aligned to the left
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        onTap: () {
                          _globalKey.currentState!.openDrawer();
                        },
                        child: Icon(Icons.menu)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome!",
                          style: TextStyle(
                              color: AppColors.greyColor, fontSize: 16.sp),
                        ),
                        Text(widget.user.name,
                            style: TextStyle(fontSize: 18.sp)),
                      ],
                    ),
                    CircleAvatar(
                      radius: 28.r,
                      backgroundImage:
                          NetworkImage(widget.user.profilePic.toString()),
                    )
                  ],
                ),
                // Categories Section
                SizedBox(height: 10.h),
                Text(
                  'Categories',
                  style: TextStyle(
                      color: AppColors.appColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 10.h),
                CatWidget(),

                // Special Offers Section
                SizedBox(height: 10.h),
                Column(
                  children: [
                    RowText(
                      title: "Special Offers",
                      btnText: "View all",
                      onTap: () {},
                    ),
                    AspectRatio(
                      aspectRatio: 16 / 7,
                      child: PageView.builder(
                        itemCount: popularServices.length,
                        controller: _pageController,
                        itemBuilder: (context, index) {
                          return popularServices[index];
                        },
                        onPageChanged: (value) {
                          setState(() {
                            _currentPage = value;
                          });
                        },
                      ),
                    ),
                    PageIndicator(
                      length: popularServices.length,
                      currentPage: _currentPage,
                    ),
                  ],
                ),

                // Popular Services Section
                SizedBox(height: 10.h),
                RowText(
                  title: "Popular Services",
                  btnText: "View all",
                  onTap: () {
                    Navigator.push(
                        context,
                        CupertinoModalPopupRoute(
                          filter: ImageFilter.blur(),
                          builder: (context) => CategoriesScreen(),
                        ));
                  },
                ),
                // The existing ListView.builder remains the same with physics handling scrolling behavior
                PapularServices(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PageIndicator extends StatefulWidget {
  final int length;
  final int currentPage;

  const PageIndicator({
    required this.length,
    required this.currentPage,
  });

  @override
  _PageIndicatorState createState() => _PageIndicatorState();
}

class _PageIndicatorState extends State<PageIndicator> {
  late List<Widget> indicators;

  @override
  void initState() {
    super.initState();
    indicators = List.generate(widget.length, (index) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: index == widget.currentPage
              ? Colors.blue
              : Colors.grey.withOpacity(0.5),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: indicators,
    );
  }
}

class RowText extends StatelessWidget {
  const RowText({
    super.key,
    required this.title,
    required this.btnText,
    required this.onTap,
  });
  final String title;
  final String btnText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 19.sp, fontWeight: FontWeight.w700),
          ),
          TextButton(
              onPressed: onTap,
              child: Text(btnText, style: TextStyle(fontSize: 14.sp)))
        ],
      ),
    );
  }
}
