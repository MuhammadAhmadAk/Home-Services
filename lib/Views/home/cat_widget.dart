import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_services/Utils/constants/assets.dart';
import 'package:home_services/Utils/constants/colors.dart';
import 'package:home_services/Views/Category/Pages/all_services.dart';
import 'package:home_services/Views/Category/Pages/carpentory_pages.dart';
import 'package:home_services/Views/Category/Pages/cleaning_services_page.dart';
import 'package:home_services/Views/Category/Pages/electricians_page.dart';
import 'package:home_services/Views/Category/Pages/painting_page.dart';

class CatWidget extends StatefulWidget {
  const CatWidget({super.key});

  @override
  State<CatWidget> createState() => _CatWidgetState();
}

class _CatWidgetState extends State<CatWidget> {
  List<String> imgPath = [
    ImgAssets.splash1,
    ImgAssets.carpentry,
    ImgAssets.cleaning,
    ImgAssets.electricity,
    ImgAssets.mechanic,
    ImgAssets.plumbering,
    ImgAssets.painting
  ];
  List<String> catName = [
    "All",
    "Carpenter",
    "Cleaner",
    "Electrician",
    "Painter"
  ];
  List<Widget> screens = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    screens = [
      Scaffold(
          appBar: AppBar(
            title: Text(catName[0], style: TextStyle(fontSize: 24.sp)),
          ),
          body: AllServices()),
      Scaffold(
          appBar: AppBar(
            title: Text(catName[1], style: TextStyle(fontSize: 24.sp)),
          ),
          body: CarpentoryServices()),
      Scaffold(
          appBar: AppBar(
            title: Text(catName[2], style: TextStyle(fontSize: 24.sp)),
          ),
          body: CleaningServices()),
      Scaffold(
          appBar: AppBar(
            title: Text(catName[3], style: TextStyle(fontSize: 24.sp)),
          ),
          body: ElectricServices()),
      Scaffold(
          appBar: AppBar(
            title: Text(catName[4], style: TextStyle(fontSize: 24.sp)),
          ),
          body: PaintingServices()),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110.h,
      child: ListView.builder(
        itemCount: screens.length,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  CupertinoModalPopupRoute(
                    builder: (context) => screens[index],
                  ));
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          spreadRadius: 2,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 60.w,
                          height: 50.h,
                          child: Image.asset(imgPath[index]),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          catName[index],
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class All extends StatefulWidget {
  const All({super.key});

  @override
  State<All> createState() => _AllState();
}

class _AllState extends State<All> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
