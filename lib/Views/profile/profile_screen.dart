import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_services/_DB%20services/Repositories/worker_profiles_repo.dart';
import 'package:home_services/Utils/Components/custom_animated_dialog.dart';
import 'package:home_services/Utils/Components/custom_button.dart';
import 'package:home_services/Utils/Components/custom_snakbar.dart';
import 'package:home_services/_DB%20services/SharedPref%20services/sharedpref_auth.dart';
import 'package:home_services/_DB%20services/bloc/Auth-Cubit/auth_cubit.dart';
import 'package:home_services/_DB%20services/bloc/Auth-Cubit/auth_state.dart';
import 'package:home_services/models/user_model.dart';

import '../../_DB services/bloc/worker-cubit/wokers_profile_cubit.dart';
import '../../_DB services/bloc/worker-cubit/wokers_profile_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool isWorkerProfile = false; // Toggle between user and worker profiles

  // Controllers for text fields
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _userContactController = TextEditingController();
  final TextEditingController _userAddressController = TextEditingController();
  TextEditingController hourlyPriceController = TextEditingController();

  // Dropdown category list and selected category

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    getUserModel();
    getProfile();
    // Initialize text field controllers
  }

  getProfile() async {
    String id = FirebaseAuth.instance.currentUser!.uid;
    // context.read<WokersProfileCubit>().getProfileById(id);
    context.read<AuthCubit>().fetchUserProfile(id);
  }

  UserModel? userModel;
  getUserModel() async {
    UserModel? _userModel = await SharedPrefAuth.getUser();
    setState(() {
      userModel = _userModel;
    });
  }

  String userProfile = "";
  bool profileExists = false;
  bool isEditable = false;

  @override
  Widget build(BuildContext context) {
    if (userModel == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()), // Loading indicator
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Text('Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        automaticallyImplyLeading: false,
        actions: [
          SlideTransition(
            position: _slideAnimation,
            child: IconButton(
              icon: Icon(
                  (isEditable == true) ? Icons.edit : Icons.edit_off_rounded),
              onPressed: () {
                setState(() {
                  isEditable = !isEditable;
                });
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Toggle switch for user/worker profile
            SizedBox(height: 10.h),
            Center(
              child: GestureDetector(
                onTap: () {
                  _animationController.forward().then((_) {
                    Future.delayed(Duration(seconds: 1), () {
                      _animationController.reverse();
                    });
                  });
                },
                child: AnimatedBuilder(
                  animation: _scaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Hero(
                        tag: 'profilePic',
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          height: 130,
                          width: 130,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.blueAccent,
                              width: 4.0,
                            ),
                            image: DecorationImage(
                              image: NetworkImage(
                                  '${userModel!.profilePic}'), // Provide a default image, // Placeholder image
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Column(
              children: [
                buildUserProfileFields(),
                SizedBox(
                  height: 20.h,
                ),
                CustomButtonWidget(
                  onPressed: () {},
                  text: "Update",
                )
              ],
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomAnimatedDialog(
          title: 'Profile Created',
          message: 'Your worker profile has been created successfully!',
          onConfirm: () {
            // You can add any action here that needs to occur after confirming
          },
        );
      },
    );
  }

  Widget buildUserProfileFields() {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthUserProfileFetchState) {
          UserModel user = state.user;
          _userNameController.text = user.name;
          _userContactController.text = user.phone;
          _userAddressController.text = "user address";
          userProfile = user.profilePic!;
        }
        return Column(
          children: [
            TextFormField(
              controller: _userNameController,
              decoration: InputDecoration(
                labelText: "Username",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            SizedBox(height: 10.h),
            TextFormField(
              controller: _userContactController,
              decoration: InputDecoration(
                labelText: 'Contact Info',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            SizedBox(height: 10.h),
            TextFormField(
              controller: _userAddressController,
              decoration: InputDecoration(
                labelText: 'Address',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _userNameController.dispose();
    _userContactController.dispose();
    _userAddressController.dispose();

    super.dispose();
  }
}
