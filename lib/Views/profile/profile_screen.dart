import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_services/Utils/constants/colors.dart';
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

  bool isEditable = false;

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _userContactController = TextEditingController();
  final TextEditingController _userAddressController = TextEditingController();

  UserModel? userModel;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
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
  }

  getProfile() async {
    String id = FirebaseAuth.instance.currentUser!.uid;
    context.read<AuthCubit>().fetchUserProfile(id);
  }

  getUserModel() async {
    UserModel? _userModel = await SharedPrefAuth.getUser();
    setState(() {
      userModel = _userModel;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (userModel == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        actions: [
          IconButton(
            icon: Icon(isEditable ? Icons.edit_off : Icons.edit),
            onPressed: () {
              setState(() {
                isEditable = !isEditable;
              });
            },
          ),
        ],
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
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
                          border:
                              Border.all(color: Colors.blueAccent, width: 4.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: Offset(0, 3),
                            ),
                          ],
                          image: DecorationImage(
                            image: NetworkImage('${userModel!.profilePic}'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20.h),
            buildUserProfileFields(),
            SizedBox(height: 20.h),
            CustomButtonWidget(
              onPressed: () {
                // Update logic here
              },
              text: "Update",
              buttonBackgroundColor: AppColors.appColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildUserProfileFields() {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthUserProfileFetchState) {
          UserModel user = state.user;
          _userNameController.text = user.name;
          _userContactController.text = user.phone;
          _userAddressController.text = "user address"; // Adjust as needed
        }
        return Column(
          children: [
            _buildTextField(_userNameController, "Username"),
            SizedBox(height: 10.h),
            _buildTextField(_userContactController, "Contact Info"),
            SizedBox(height: 10.h),
            _buildTextField(_userAddressController, "Address"),
          ],
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        enabled: isEditable,
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        ),
      ),
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
