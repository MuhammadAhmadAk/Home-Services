import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_services/Utils/Components/custom_button.dart';

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

  final bool isWorker =
      false; // true if the profile belongs to a worker, false for a user
  final String name = "John Doe";
  final String profession = "Plumber"; // Use empty string for users
  final String contactInfo = "123-456-7890";
  final String address = "123 Elm Street, Springfield";
  final String bio =
      "Experienced plumber with over 10 years in the field. Available for all types of plumbing jobs.";
  final double rating = 4.5; // Use 0.0 for users
  final String experience =
      "10 years of professional plumbing experience"; // Use empty string for users

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
  }

  @override
  Widget build(BuildContext context) {
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
              icon: Icon(Icons.edit),
              onPressed: () {
                // Navigate to edit profile screen
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding:  EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                              image: AssetImage(
                                  'assets/images/p.jpg'), // Placeholder image
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
            FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 22.sp,
                          color: Colors.black87,
                        ),
                  ),
                  if (profession.isNotEmpty)
                    Text(
                      profession,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[700],
                          ),
                    ),
                  if (rating > 0.0)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 24),
                        SizedBox(width: 4),
                        Text(
                          '${rating.toStringAsFixed(1)}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  SizedBox(height: 10.h),
                  if (experience.isNotEmpty)
                    Card(
                      elevation: 3,
                      child: ExpansionTile(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r)),
                        title: Text(
                          'Experience',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        children: [
                          Padding(
                            padding: EdgeInsets.all(5),
                            child: Text(
                              experience,
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(height: 8.h),
                  Card(
                    elevation: 3,
                    child: ListTile(
                      title: Text(
                        'Contact Info',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      subtitle: Text(
                        contactInfo,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Card(
                    elevation: 3,
                    child: ListTile(
                      title: Text(
                        'Address',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      subtitle: Text(
                        address,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Card(
                    elevation: 3,
                    child: ExpansionTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r)),
                      title: Text(
                        'Bio',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            bio,
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            Center(
              child: CustomButtonWidget(
                onPressed: (){},
              text: "Logout",
              
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
