import 'package:custom_line_indicator_bottom_navbar/custom_line_indicator_bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_services/Utils/constants/colors.dart';
import 'package:home_services/Views/Category/categories.dart';
import 'package:home_services/Views/Wokers_views/home/worker_home.dart';
import 'package:home_services/Views/home/home_screen.dart';
import 'package:home_services/Views/profile/profile_screen.dart';
import 'package:home_services/Views/shop/productspage.dart';
import 'package:home_services/_DB%20services/SharedPref%20services/sharedpref_auth.dart';
import 'package:home_services/models/user_model.dart';
import 'package:line_icons/line_icons.dart';

import 'booking/booking.dart';

class CustomNavbar extends StatefulWidget {
  const CustomNavbar({super.key});

  @override
  State<CustomNavbar> createState() => _CustomNavbarState();
}

class _CustomNavbarState extends State<CustomNavbar> {
  int _selectedIndex = 0;
  UserModel? user;
  List<Widget>? _widgetOptions;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    user = (await SharedPrefAuth.getUser())!;
    setState(() {
      _widgetOptions = [
        (user!.userType == "User")
            ? HomeScreen(
                user: user!,
              )
            : WorkerHomeScreen(),
        CategoriesScreen(),
        ProductPage(),
        BookingScreen(),
        ProfileScreen()
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    // Check if both user and widgetOptions are initialized
    if (user == null || _widgetOptions == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()), // Loading indicator
      );
    }

    return Scaffold(
      body: Center(
        child: _widgetOptions!
            .elementAt(_selectedIndex), // Use _widgetOptions safely
      ),
      bottomNavigationBar: Container(
        color: AppColors.appColor,
        height: 70.h,
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: CustomLineIndicatorBottomNavbar(
          selectedColor: AppColors.whiteColor,
          unSelectedColor: Color.fromARGB(136, 207, 207, 207),
          backgroundColor: AppColors.appColor,
          selectedIconSize: 25.r,
          unselectedIconSize: 20.r,
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          enableLineIndicator: false,
          lineIndicatorWidth: 3,
          indicatorType: IndicatorType.Top,
          customBottomBarItems: [
            CustomBottomBarItems(
              label: 'Home',
              icon: LineIcons.home,
            ),
            CustomBottomBarItems(
              label: 'Categories',
              icon: Icons.category,
            ),
            CustomBottomBarItems(
              label: 'Shop',
              icon: Icons.store_mall_directory,
            ),
            CustomBottomBarItems(
              label: 'Bookings',
              icon: Icons.book_online,
            ),
            CustomBottomBarItems(
              label: 'Profile',
              icon: Icons.person,
            ),
          ],
        ),
      ),
    );
  }
}
