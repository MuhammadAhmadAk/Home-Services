import 'package:flutter/material.dart';
import 'package:home_services/Utils/constants/assets.dart';

import '../../../Utils/Components/service_widget.dart';

class CleaningServices extends StatefulWidget {
  const CleaningServices({super.key});

  @override
  State<CleaningServices> createState() => _CleaningServicesState();
}

class _CleaningServicesState extends State<CleaningServices> {
  List<String> catName = [
    "Carpenter",
    "Cleaner",
    "Electrician",
    "Mechanic",
    "Plumber",
    "Painter"
  ];
  List<String> name = [
    "kong",
    "Peter",
    "Johnson",
    "John wick",
    "Gojo",
    "Tanjaro"
  ];
  List<String> imgPath = [
    ImgAssets.profileImg4,
    ImgAssets.profileImg5,
    ImgAssets.profileImg6,
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
                profession: "Cleaner",
                price: price[index],
                ratting: rating[index]);
          },
        ),
      ),
    );
  }
}
