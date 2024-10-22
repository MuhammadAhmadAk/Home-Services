import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_services/Utils/constants/colors.dart';
import 'package:home_services/Views/booking/hire_now_screen.dart';

class DetailPage extends StatefulWidget {
  final String imgUrl;
  final String name;
  final String rating;
  final String price;
  final Map<String, dynamic> allDetails;

  const DetailPage({
    super.key,
    required this.imgUrl,
    required this.name,
    required this.rating,
    required this.price,
    required this.allDetails,
  });

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> with TickerProviderStateMixin {
  // Animation controllers for image and card
  late AnimationController _imageController;
  late AnimationController _cardController;
  late Animation<double> _imageAnimation;
  late Animation<double> _cardAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize controllers for the animations
    _imageController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _cardController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Tween for the image animation (fades and scales in)
    _imageAnimation = CurvedAnimation(
      parent: _imageController,
      curve: Curves.easeOut,
    );

    // Tween for the card animation (fades and slides up)
    _cardAnimation = CurvedAnimation(
      parent: _cardController,
      curve: Curves.easeOut,
    );

    // Start animations after short delay
    _imageController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _cardController.forward();
    });
  }

  @override
  void dispose() {
    _imageController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(widget.name, style: TextStyle(fontSize: 20)),

        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black), // Back icon color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Animated Image with Hero animation for smoother transitions
            Hero(
              tag: widget.imgUrl,
              child: ScaleTransition(
                scale: _imageAnimation,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      widget.imgUrl,
                      height: 300.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Animated Card for the Worker Info
            FadeTransition(
              opacity: _cardAnimation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.2), // Slide up animation
                  end: Offset.zero,
                ).animate(_cardController),
                child: Container(
                  height: 300.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Worker Name
                      Text(
                        widget.name,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Rating Row
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 22),
                          const SizedBox(width: 5),
                          Text(
                            "${widget.rating}/5.0",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF757575),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Price and Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Price Text
                          Text(
                            "\$${widget.price} per hour",
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF3F51B5),
                            ),
                          ),
                          // Hire Button with subtle animation
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  CupertinoDialogRoute(
                                      builder: (context) => HireNowScreen(
                                            workerdetails: widget.allDetails,
                                          ),
                                      context: context));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.appColor,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 5,
                            ),
                            child: const Text(
                              "Hire Now",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      // Contact Button
                      Center(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // Contact action
                          },
                          icon: const Icon(Icons.message, color: Colors.blue),
                          label: const Text(
                            "Contact",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 50,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
