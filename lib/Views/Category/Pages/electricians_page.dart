import 'package:flutter/material.dart';

import '../../../Utils/Components/service_widget.dart';
import '../../../Utils/constants/assets.dart';

class ElectricServices extends StatefulWidget {
  const ElectricServices({super.key});

  @override
  State<ElectricServices> createState() => _ElectricServicesState();
}

class _ElectricServicesState extends State<ElectricServices> {
  List<String> catName = [
    "Carpenter",
    "Cleaner",
    "Electrician",
    "Mechanic",
    "Plumber",
    "Painter"
  ];
  List<String> name = [
    "Paul",
    "Peter",
    "Johnson",
    "John wick",
    "Gojo",
    "Tanjaro"
  ];

  List<String> imgPath = [
    ImgAssets.profileImg6,
    ImgAssets.profileImg5,
    ImgAssets.profileImg4,
    ImgAssets.profileImg1,
    ImgAssets.profileImg2,
    ImgAssets.profileImg3,
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
                profession: "Electrician",
                price: price[index],
                ratting: rating[index]);
          },
        ),
      ),
    );
  }
}
