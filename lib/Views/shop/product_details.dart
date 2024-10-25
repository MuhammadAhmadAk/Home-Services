import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_services/Views/shop/orders/create_order_page.dart';

import '../../Utils/constants/colors.dart';

class ProductDetailsPage extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailsPage({required this.product});

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    log("Details Page: ${widget.product}");
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ensure product image URL exists
            Hero(
              tag: product['id'] ?? 'unknown', // Fallback if id is null
              child: product['imageUrl'] != null
                  ? Image.network(
                      product['imageUrl'],
                      width: double.infinity,
                      height: 300.h,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: double.infinity,
                      height: 300.h,
                      color: Colors.grey,
                      child: Icon(
                        Icons.image,
                        size: 100,
                        color: Colors.white,
                      ),
                    ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product['name'] ?? "No Name Available",
                            style: GoogleFonts.poppins(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            product['price'] != null
                                ? '\$${product['price']}'
                                : 'Price not available',
                            style: GoogleFonts.poppins(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.green,
                            ),
                          ),
                          SizedBox(height: 15.h),
                          Text(
                            'Description',
                            style: GoogleFonts.poppins(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            product['description'] ??
                                "No description available",
                            style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.black54,
                            ),
                          ),
                          SizedBox(height: 20.h),
                          Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 50.w, vertical: 15.h),
                                backgroundColor: AppColors.appColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                // Navigate to checkout page with product details
                                // Navigate.push(context, ...);

                                Map<String, dynamic> prd = {
                                  'id': product['id'],
                                  'name': product['name'],
                                  'price': product['price'],
                                  'imageUrl': product['imageUrl'],
                                  'quantity':
                                      1, // Placeholder value, replace with actual quantity selected by user
                                };
                                Navigator.push(
                                    context,
                                    CupertinoDialogRoute(
                                        builder: (context) =>
                                            SingleOrderCheckoutPage(
                                              itemName: product['name'],
                                              itemPrice: double.parse(
                                                  product['price']),
                                              itemImage: product['imageUrl'],
                                            ),
                                        context: context));
                              },
                              child: Text(
                                'Place Order',
                                style: GoogleFonts.poppins(
                                  fontSize: 16.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
