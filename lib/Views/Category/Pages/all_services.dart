import 'package:flutter/material.dart';
import 'package:home_services/Utils/Components/service_widget.dart';
import 'package:home_services/Utils/constants/assets.dart';

class AllServices extends StatefulWidget {
  const AllServices({super.key});

  @override
  State<AllServices> createState() => _AllServicesState();
}

class _AllServicesState extends State<AllServices> {
  List<String> catName = [
    "Carpenter",
    "Cleaner",
    "Electrician",
    "Mechanic",
    "Plumber",
    "Painter"
  ];
  List<String> imgPath = [
    ImgAssets.profileImg1,
    ImgAssets.profileImg2,
    ImgAssets.profileImg3,
    ImgAssets.profileImg4,
    ImgAssets.profileImg5,
    ImgAssets.profileImg6,
  ];
  List<String> name = [
    "johny",
    "Peter",
    "Johnson",
    "John wick",
    "Gojo",
    "Tanjaro"
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
                profession: catName[index],
                price: price[index],
                ratting: rating[index]);
          },
        ),
      ),
    );
  }
}
