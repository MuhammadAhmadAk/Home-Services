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

class WorkerProfileScreen extends StatefulWidget {
  const WorkerProfileScreen({super.key});

  @override
  _WorkerProfileScreenState createState() => _WorkerProfileScreenState();
}

class _WorkerProfileScreenState extends State<WorkerProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Controllers for text fields
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _userContactController = TextEditingController();
  final TextEditingController _userAddressController = TextEditingController();
  final TextEditingController _workerNameController = TextEditingController();
  final TextEditingController _workerContactController =
      TextEditingController();
  TextEditingController hourlyPriceController = TextEditingController();
  final TextEditingController _workerAddressController =
      TextEditingController();
  final TextEditingController _workerBioController = TextEditingController();
  final TextEditingController _workerExperienceController =
      TextEditingController();
  String? _selectedCategory = 'Painting'; // Default selected category

  // Dropdown category list and selected category
  List<String> _workerCategories = [
    'Plumber',
    'Electrician',
    'Carpenter',
    'Painter',
    'Mechanic'
  ];
  final List<String> uniqueCategories = []; // Convert to Set and back to List
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
    uniqueCategories == _workerCategories.toSet().toList();
    getUserData();
    getProfile();
    // Initialize text field controllers
  }

  getProfile() async {
    String id = FirebaseAuth.instance.currentUser!.uid;
    context.read<WokersProfileCubit>().getProfileById(id);
    context.read<AuthCubit>().fetchUserProfile(id);
  }

  UserModel? userModel;
  getUserData() async {
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
    // Check if both user and widgetOptions are initialized
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Rating ( 5"),
                Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 20.w,
                ),
                Text(")"),
              ],
            ),

            BlocConsumer<WokersProfileCubit, WokersProfileState>(
              listener: (context, createstate) {
                if (createstate is WokersProfileProfileCreatedState) {
                  _showSuccessDialog(context);
                } else if (createstate is WorkerProfileErrorState) {
                  showMessage(context, "Error", createstate.errorMessage);
                }
              },
              builder: (context, createstate) {
                return Column(
                  children: [
                    buildWorkerProfileFields(),
                    SizedBox(
                      height: 20.h,
                    ),
                    Center(
                        child: (createstate is WokersProfileLoading)
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : (isEditable == true)
                                ? CustomButtonWidget(
                                    onPressed: () {
                                      // Save profile data (e.g., send to server or update local storage)
                                      _saveProfileData();
                                    },
                                    text: (profileExists == true)
                                        ? "Update"
                                        : "Create Profile",
                                  )
                                : Container()),
                  ],
                );
              },
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

  Widget buildWorkerProfileFields() {
    return BlocBuilder<WokersProfileCubit, WokersProfileState>(
      builder: (context, state) {
        if (state is WokersProfileProfileFetchedState) {
          Map<String, dynamic>? profileData = state.wokersProfile;

          if (profileData == null ||
              profileData["name"] == null ||
              profileData["contactInfo"] == null ||
              profileData["address"] == null ||
              profileData["experience"] == null ||
              profileData["bio"] == null ||
              profileData["category"] == null ||
              profileData["name"].isEmpty ||
              profileData["contactInfo"].isEmpty ||
              profileData["address"].isEmpty ||
              profileData["experience"].isEmpty ||
              profileData["bio"].isEmpty ||
              profileData["category"].isEmpty) {
            profileExists = false; // No valid data means create profile
          } else {
            profileExists = true; // Valid data exists, update profile
            // Populate the text controllers with the existing data
            _workerNameController.text = profileData["name"] ?? '';
            _workerContactController.text = profileData["contactInfo"] ?? '';
            _workerAddressController.text = profileData["address"] ?? '';
            _workerExperienceController.text = profileData["experience"] ?? '';
            _workerBioController.text = profileData["bio"] ?? '';
            _selectedCategory = profileData["category"] ?? '';
            hourlyPriceController.text = profileData["hourlyPrice"] ?? "";
          }
        }

        return Column(
          children: [
            TextFormField(
              enabled: isEditable,
              controller: _workerNameController,
              decoration: InputDecoration(
                labelText: 'Worker Name',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            SizedBox(height: 10.h),
            // Dropdown for worker category
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                enabled: isEditable,
                labelText: 'Category',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              value: _selectedCategory,
              items: uniqueCategories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedCategory = newValue; // Update the selected category
                });
              },
            ),
            SizedBox(height: 10.h),
            TextFormField(
              enabled: isEditable,
              keyboardType: TextInputType.number,
              controller: _workerContactController,
              decoration: InputDecoration(
                labelText: 'Contact Info',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            SizedBox(height: 10.h),
            TextFormField(
              enabled: isEditable,
              controller: _workerAddressController,
              decoration: InputDecoration(
                labelText: 'Address',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            SizedBox(height: 10.h),
            TextFormField(
              enabled: isEditable,
              controller: _workerExperienceController,
              decoration: InputDecoration(
                labelText: 'Experience',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            SizedBox(height: 10.h),
            TextFormField(
              enabled: isEditable,
              controller: hourlyPriceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Hourly Price',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            SizedBox(height: 10.h),
            TextFormField(
              enabled: isEditable,
              controller: _workerBioController,
              decoration: InputDecoration(
                labelText: 'Bio',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        );
      },
    );
  }

  void _saveProfileData() {
    if (profileExists) {
      print("Saving worker profile...");
      print("Name: ${_workerNameController.text}");
      print("Category: $_selectedCategory");
      print("Contact Info: ${_workerContactController.text}");
      print("Address: ${_workerAddressController.text}");
      print("Experience: ${_workerExperienceController.text}");
      print("Bio: ${_workerBioController.text}");
      context.read<WokersProfileCubit>().updateWorkersProfile(
          name: _workerNameController.text,
          category: _selectedCategory!,
          contactInfo: _workerContactController.text,
          address: _workerAddressController.text,
          experience: _workerExperienceController.text,
          bio: _workerBioController.text,
          hourlyPrice: hourlyPriceController.text,
          profilePicture: userModel!.profilePic);
    } else {
      print("Creating new worker profile...");
      print("Name: ${_workerNameController.text}");
      print("Category: $_selectedCategory");
      print("Contact Info: ${_workerContactController.text}");
      print("Address: ${_workerAddressController.text}");
      print("Experience: ${_workerExperienceController.text}");
      print("Bio: ${_workerBioController.text}");
      print("Hourly Price: ${hourlyPriceController.text}");
      context.read<WokersProfileCubit>().createWorkersProfile(
          name: _workerNameController.text,
          category: _selectedCategory!,
          contactInfo: _workerContactController.text,
          address: _workerAddressController.text,
          experience: _workerExperienceController.text,
          bio: _workerBioController.text,
          hourlyprice: hourlyPriceController.text,
          profilePicture: userModel!.profilePic!);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _userNameController.dispose();
    _userContactController.dispose();
    _userAddressController.dispose();
    _workerNameController.dispose();
    _workerContactController.dispose();
    _workerAddressController.dispose();
    _workerBioController.dispose();
    _workerExperienceController.dispose();
    super.dispose();
  }
}
