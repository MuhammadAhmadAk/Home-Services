import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/colors.dart';

class ServiceWidget extends StatefulWidget {
  const ServiceWidget(
      {super.key,
      required this.name,
      required this.profession,
      required this.price,
      required this.ratting,
      required this.imgPath});
  final String name;
  final String profession;
  final String price;
  final String ratting;
  final String imgPath;
  @override
  State<ServiceWidget> createState() => _ServiceWidgetState();
}

class _ServiceWidgetState extends State<ServiceWidget> {
  late bool isFavourite = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 120.h,
          width: 330.w,
          margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
          decoration: BoxDecoration(
              color: AppColors.greyColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              Container(
                height: 118.h,
                width: 110.w,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover, image: AssetImage(widget.imgPath)),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                        color: AppColors.darkBlueColor.withOpacity(0.2))),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 8.h,
                    ),
                    Row(
                      children: [
                        Text(widget.name,
                            style: TextStyle(
                                fontSize: 16.sp, fontWeight: FontWeight.w600)),
                        SizedBox(
                          width: 60,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Text("${widget.profession}",
                        style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.greyColor)),
                    SizedBox(
                      height: 2.h,
                    ),
                    Row(
                      children: [
                        Text("\$${widget.price}",
                            style: TextStyle(
                                fontSize: 16.sp, fontWeight: FontWeight.w600)),
                        Text("(Per Hour)",
                            style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.greyColor))
                      ],
                    ),
                    SizedBox(
                      height: 7.h,
                    ),
                    Row(
                      children: [
                        Container(
                          width: 53.w,
                          height: 22.h,
                          decoration: BoxDecoration(
                            color: AppColors.greyColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 2.w,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 20.w,
                                ),
                                Text("(${widget.ratting})",
                                    style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.greyColor))
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Text("44 Reviews",
                            style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.greyColor))
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        Positioned(
            top: 14.h,
            left: 300.w,
            child: GestureDetector(
                onTap: () {
                  setState(() {
                    isFavourite = !isFavourite;
                  });
                },
                child: Icon(isFavourite
                    ? Icons.favorite_border_outlined
                    : Icons.favorite)))
      ],
    );
  }
}
