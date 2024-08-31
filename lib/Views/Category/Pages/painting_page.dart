import 'package:flutter/material.dart';
import 'package:home_services/Utils/constants/assets.dart';

import '../../../Utils/Components/service_widget.dart';

class PaintingServices extends StatefulWidget {
  const PaintingServices({super.key});

  @override
  State<PaintingServices> createState() => _PaintingServicesState();
}

class _PaintingServicesState extends State<PaintingServices> {
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
    "John wick",
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
  List<String> rating = ["4,0", "4.2", "5.0", "3.5", "2.9", "5.0"];
  List<String> price = ["40", "20", "50", "35", "29", "50"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
          itemCount: 6,
          itemBuilder: (BuildContext context, int index) {
            return ServiceWidget(
                imgPath: imgPath[index],
                name: name[index],
                profession: "Painter",
                price: price[index],
                ratting: rating[index]);
          },
        ),
      ),
    );
  }
}
