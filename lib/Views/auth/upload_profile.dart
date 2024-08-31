import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_services/Services/storage_services.dart';
import 'package:home_services/Utils/Components/app_loader.dart';
import 'package:home_services/Utils/Components/custom_button.dart';
import 'package:home_services/Utils/Components/custom_snakbar.dart';
import 'package:home_services/Views/auth/login.dart';
import 'package:home_services/bloc/Auth-Cubit/auth_cubit.dart';
import 'package:home_services/bloc/Auth-Cubit/auth_state.dart';

class UploadProfile extends StatefulWidget {
  const UploadProfile({super.key, required this.userId});
  final String userId;
  @override
  State<UploadProfile> createState() => _UploadProfileState();
}

class _UploadProfileState extends State<UploadProfile> {
  StorageServices services = StorageServices();
  String? imgUrl;
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthProfileUploadedState) {
          showMessage(context, "Success", "Profile Updated");
          Navigator.pop(context);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LoginScreen(),
              ));
        } else if (state is AuthLoadingState) {
          AppLoading(context: context, msg: "Uploading...");
        } else if (state is AuthErrorState) {
          showMessage(context, "Error", "Upload failed");
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Upload Profile',
                  style: TextStyle(fontSize: 30.sp),
                ),
                Hero(
                  tag: 'profile_picture', // Unique tag for Hero animation
                  child: CircleAvatar(
                    radius: 150.r,
                    backgroundColor: Colors.grey[200],
                    backgroundImage:
                        imgUrl != null ? NetworkImage(imgUrl!) : null,
                    child: GestureDetector(
                      onTap: () async {
                        String? url =
                            await services.uploadProfilePicture(user!.uid);
                        setState(() {
                          imgUrl = url;
                        });
                      },
                      child: imgUrl == null
                          ? Icon(Icons.person, size: 80, color: Colors.grey)
                          : null,
                    ),
                  ),
                ),
                SizedBox(height: 70.h),
                CustomButtonWidget(
                  text: "Upload Profile",
                  onPressed: () async {
                   await context.read<AuthCubit>().updateProfilePic(imgUrl!);
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
