import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_services/Utils/constants/colors.dart';

class ServiceWidget extends StatefulWidget {
  const ServiceWidget({
    super.key,
    required this.name,
    required this.profession,
    required this.price,
    required this.ratting,
    required this.imgPath,
  });

  final String name;
  final String profession;
  final String price;
  final String ratting;
  final String imgPath;

  @override
  State<ServiceWidget> createState() => _ServiceWidgetState();
}

class _ServiceWidgetState extends State<ServiceWidget> with SingleTickerProviderStateMixin {
  late bool isFavourite = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.all(8.w),
          child: Container(
            child: GestureDetector(
              onTap: _animateFavorite,
              child: Container(
                height: 140.h,
                width: double.infinity,
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Service Image
                    Container(
                      height: 100.h,
                      width: 100.w,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(widget.imgPath),
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: AppColors.darkBlueColor.withOpacity(0.2),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    // Service Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(widget.name, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
                          SizedBox(height: 6.h),
                          Text(widget.profession, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500, color: AppColors.greyColor)),
                          SizedBox(height: 6.h),
                          Row(
                            children: [
                              Text("\$${widget.price}", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
                              SizedBox(width: 6.w),
                              Text("(Per Hour)", style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: AppColors.greyColor)),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            children: [
                              // Rating with Star Icon
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 6.w),
                                height: 24.h,
                                decoration: BoxDecoration(
                                  color: AppColors.greyColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.star_rounded, color: Colors.amber, size: 18.w),
                                    SizedBox(width: 4.w),
                                    Text(widget.ratting, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500, color: AppColors.greyColor)),
                                  ],
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Text("44 Reviews", style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500, color: AppColors.greyColor)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        // Favorite Button with Animation
        Positioned(
          top: 12.h,
          right: 16.w,
          child: GestureDetector(
            onTap: () {
              setState(() {
                isFavourite = !isFavourite;
                isFavourite ? _animationController.forward() : _animationController.reverse();
              });
            },
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Icon(
                isFavourite ? Icons.favorite : Icons.favorite_border_outlined,
                color: isFavourite ? Colors.red : Colors.grey,
                size: 28.w,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Method to animate favorite button
  void _animateFavorite() {
    if (isFavourite) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
  }
}
