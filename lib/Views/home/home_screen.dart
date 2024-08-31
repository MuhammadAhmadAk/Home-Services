import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_services/Utils/Components/service_widget.dart';
import 'package:home_services/Utils/constants/assets.dart';
import 'package:home_services/Utils/constants/colors.dart';
import 'package:home_services/models/user_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.user});
  final UserModel user;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Color> catColor = [
    Colors.pink.withOpacity(0.1),
    Colors.blue.withOpacity(0.1),
    Colors.brown.withOpacity(0.1),
    AppColors.appColor.withOpacity(0.1),
    Colors.pink.withOpacity(0.1),
    Colors.blue.withOpacity(0.1),
    Colors.brown.withOpacity(0.1),
  ];
  List<String> imgPath = [
    ImgAssets.splash1,
    ImgAssets.carpentry,
    ImgAssets.cleaning,
    ImgAssets.electricity,
    ImgAssets.mechanic,
    ImgAssets.plumbering,
    ImgAssets.painting
  ];
  List<String> imgPath2 = [
    ImgAssets.profileImg1,
    ImgAssets.profileImg2,
    ImgAssets.profileImg3,
    ImgAssets.profileImg4,
    ImgAssets.profileImg5,
    ImgAssets.profileImg6,
  ];
  List<String> catName = [
    "All",
    "Carpenter",
    "Cleaner",
    "Electrician",
    "Mechanic",
    "Plumber",
    "Painter"
  ];
  List<String> name = [
    "johny",
    "Peter",
    "Johnson",
    "John wick",
    "Gojo",
    "Tanjaro"
  ];
  late PageController _pageController;
  late Timer _timer;

  int _currentPage = 0;
  List<Widget> popularServices = [
    for (int i = 0; i < 3; i++) ...[
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Container(
          height: 40.h,
          width: 330.w,
          decoration: BoxDecoration(
              color: AppColors.appColor.withOpacity(0.9),
              borderRadius: BorderRadius.circular(10.r)),
          child: Center(
            child: Text(
              "Get Discount Upto 40%",
              style: TextStyle(fontSize: 20.sp, color: AppColors.whiteColor),
            ),
          ),
        ),
      ),
    ],
  ];
  @override
  void initState() {
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

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 28.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome",
                      style: TextStyle(
                          color: AppColors.greyColor, fontSize: 15.sp),
                    ),
                    Text(widget.user.name, style: TextStyle(fontSize: 18.sp)),
                  ],
                ),
                CircleAvatar(
                  radius: 28.r,
                  backgroundImage:
                      NetworkImage(widget.user.profilePic.toString()),
                )
              ],
            ),
          ),
          Column(
            children: [
              SizedBox(
                height: 20.h,
              ),
              RowText(
                title: "Categories",
                btnText: "View all",
                onTap: () {},
              ),
              Container(
                height: 110.h,
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                child: ListView.builder(
                  itemCount: imgPath.length,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: [
                          CircleAvatar(
                            backgroundColor: catColor[index],
                            radius: 40.r,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(imgPath[index]),
                            ),
                          ),
                          Text(catName[index])
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Column(
            children: [
              RowText(
                title: "Special Offers",
                btnText: "View all",
                onTap: () {},
              ),
              AspectRatio(
                aspectRatio: 16 / 5,
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
          SizedBox(
            height: 10.h,
          ),
          Column(
            children: [
              RowText(
                title: "Papular Services",
                onTap: () {},
                btnText: 'View all',
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: imgPath2.length,
              itemBuilder: (BuildContext context, int index) {
                return ServiceWidget(
                    imgPath: imgPath2[index],
                    name: name[index],
                    profession: "Developer",
                    price: "29",
                    ratting: "20");
              },
            ),
          ),
        ],
      )),
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
      padding: EdgeInsets.symmetric(horizontal: 28.w),
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