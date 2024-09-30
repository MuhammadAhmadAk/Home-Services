import 'package:flutter/material.dart';
import 'package:home_services/Utils/constants/assets.dart';
import 'package:home_services/Utils/constants/colors.dart';
import 'package:home_services/Utils/Components/service_widget.dart';

class PaintingServices extends StatefulWidget {
  const PaintingServices({super.key});

  @override
  State<PaintingServices> createState() => _PaintingServicesState();
}

class _PaintingServicesState extends State<PaintingServices>
    with SingleTickerProviderStateMixin {
  List<String> catName = [
    "Carpenter",
    "Cleaner",
    "Electrician",
    "Mechanic",
    "Plumber",
    "Painter"
  ];
  List<String> name = [
    "Parker",
    "Peter",
    "Johnson",
    "John Wick",
    "Gojo",
    "Tanjaro"
  ];
  List<String> imgPath = [
    ImgAssets.profileImg3,
    ImgAssets.profileImg1,
    ImgAssets.profileImg5,
    ImgAssets.profileImg2,
    ImgAssets.profileImg4,
    ImgAssets.profileImg7,
  ];
  List<String> rating = ["4.0", "4.2", "5.0", "3.5", "2.9", "5.0"];
  List<String> price = ["40", "20", "50", "35", "29", "50"];

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: name.length,
            itemBuilder: (BuildContext context, int index) {
              // Staggered animation delay
              final delay = index * 100;
              return AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.0, 0.5),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: _controller,
                        curve:
                            Interval(0.1 * index, 1.0, curve: Curves.easeOut),
                      )),
                      child: GestureDetector(
                        onTap: () {
                          _showDetail(context, index);
                        },
                        child: ScaleTransition(
                          scale: _scaleAnimation,
                          child: ServiceWidget(
                            imgPath: imgPath[index],
                            name: name[index],
                            profession: "Painter",
                            price: price[index],
                            ratting: rating[index],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  // A method to build the service card with advanced UI

  // Show detail page with hero transition
  void _showDetail(BuildContext context, int index) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return DetailPage(
        imgPath: imgPath[index],
        name: name[index],
        rating: rating[index],
        price: price[index],
      );
    }));
  }
}

class DetailPage extends StatelessWidget {
  final String imgPath;
  final String name;
  final String rating;
  final String price;

  const DetailPage({
    super.key,
    required this.imgPath,
    required this.name,
    required this.rating,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        backgroundColor: AppColors.appColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Hero(
              tag: imgPath,
              child: Image.asset(imgPath, height: 200, fit: BoxFit.cover),
            ),
            const SizedBox(height: 20),
            Text(
              name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Rating: $rating",
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Text(
              "\$$price per service",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
