import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_services/Utils/Components/custom_button.dart';
import 'package:home_services/Utils/constants/colors.dart';
import 'package:home_services/Views/Wokers_views/work_bottombar.dart';
import 'package:home_services/Views/auth/login.dart';
import 'package:home_services/Views/bottom_navbar.dart';
import 'package:home_services/_DB%20services/SharedPref%20services/shared_pref_workers_profiles.dart';
import 'package:home_services/_DB%20services/SharedPref%20services/sharedpref_auth.dart';
import 'package:home_services/models/user_model.dart';

import '../../Views/Wokers_views/w_profile.dart';

class WorkerDrawer extends StatelessWidget {
  final UserModel user;

  const WorkerDrawer({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.appColor, Colors.lightBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            // Drawer Header
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.transparent, // Transparent header
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(user.profilePic ?? ''),
                  ),
                  SizedBox(height: 10),
                  Text(
                    user.name ?? 'Worker Name',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
            // Drawer Items
            Expanded(
              child: ListView(
                children: [
                  _buildAnimatedListTile(
                    context,
                    icon: Icons.home,
                    title: 'Home',
                    route: () {}, // Navigate to Home
                  ),
                  _buildAnimatedListTile(
                    context,
                    icon: Icons.person,
                    title: 'Profile',
                    route: () {}, // Navigate to Profile
                  ),
                  _buildAnimatedListTile(
                    context,
                    icon: Icons.settings,
                    title: 'Settings',
                    route: () {}, // Navigate to Settings
                  ),
                  _buildAnimatedListTile(
                    context,
                    icon: Icons.exit_to_app,
                    title: 'Logout',
                    route: () {
                      SharedPrefAuth.clearAuthData();
                      SharedPrefWorkerProfiles.clearWorkerProfiles();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    }, // Handle Logout
                  ),
                ],
              ),
            ),
            // Bottom Button for Worker Profile
            CustomButtonWidget(
              buttonborderRadius: 1.r,
              textColor: AppColors.appColor,
              buttonBackgroundColor: AppColors.whiteColor,
              text: "User Profile",
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CustomNavbar(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedListTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback route,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 300),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: ListTile(
              leading: Icon(icon, color: Colors.white),
              title: Text(
                title,
                style: TextStyle(color: Colors.white),
              ),
              onTap: route,
            ),
          ),
        );
      },
    );
  }
}
