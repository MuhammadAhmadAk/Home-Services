import 'package:custom_line_indicator_bottom_navbar/custom_line_indicator_bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_services/Utils/constants/colors.dart';
import 'package:home_services/Views/Category/categories.dart';
import 'package:home_services/Views/Wokers_views/home/worker_home.dart';
import 'package:home_services/Views/home/home_screen.dart';
import 'package:home_services/Views/profile/profile_screen.dart';
import 'package:home_services/Views/shop/productspage.dart';
import 'package:home_services/models/user_model.dart';
import 'package:line_icons/line_icons.dart';

class CustomNavbar extends StatefulWidget {
  const CustomNavbar({super.key, this.user});
  final UserModel? user;
  @override
  State<CustomNavbar> createState() => _CustomNavbarState();
}

class _CustomNavbarState extends State<CustomNavbar> {
  int _selectedIndex = 0;
  late List<Widget> _widgetOptions;
  void initState() {
    super.initState();
    _widgetOptions = [
      (widget.user!.userType == "User")
          ? HomeScreen(
              user: widget.user!,
            )
          : WorkerHomeScreen(),
      CategoriesScreen(),
      ProductPage(),
      Text('Booking'),
      ProfileScreen()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
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
