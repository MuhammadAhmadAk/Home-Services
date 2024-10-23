import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_services/Views/Category/Pages/detailspage.dart';
import 'package:home_services/_DB%20services/SharedPref%20services/shared_pref_workers_profiles.dart';
import 'package:home_services/_DB%20services/bloc/worker-cubit/wokers_profile_state.dart';

import '../../../Utils/Components/service_widget.dart';
import '../../../Utils/constants/assets.dart';
import '../../../Utils/constants/colors.dart';
import '../../../_DB services/bloc/worker-cubit/wokers_profile_cubit.dart';

class ElectricServices extends StatefulWidget {
  const ElectricServices({super.key});

  @override
  State<ElectricServices> createState() => _ElectricServicesState();
}

class _ElectricServicesState extends State<ElectricServices>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> electricProfiles = [];

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    getProfiles();
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

  saveProfiles(List<Map<String, dynamic>> newProfiles) async {
    await SharedPrefWorkerProfiles.storeWorkerProfiles(newProfiles);
    setState(() {
      electricProfiles = newProfiles;
    });
  }

  getProfiles() async {
    String id = FirebaseAuth.instance.currentUser!.uid;
    List<Map<String, dynamic>>? savedProfiles =
        await SharedPrefWorkerProfiles.getWorkerProfiles();
    log("All saved profiles $savedProfiles");
    if (savedProfiles != null) {
      setState(() {
        electricProfiles = savedProfiles;
      });
    }
    context.read<WokersProfileCubit>().getWorkerByCategory("Electrician", id);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return BlocConsumer<WokersProfileCubit, WokersProfileState>(
            listener: (context, state) {
              if (state is WokersAllProfileProfileFetchState) {
                saveProfiles(state.wokersProfile);
              }
            },
            builder: (context, state) {
              return (electricProfiles.isEmpty)
                  ? Center(
                      child: Text("No Wokers Avalible"),
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: electricProfiles.length,
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
                                  curve: Interval(0.1 * index, 1.0,
                                      curve: Curves.easeOut),
                                )),
                                child: GestureDetector(
                                  onTap: () {},
                                  child: ScaleTransition(
                                    scale: _scaleAnimation,
                                    child: ServiceWidget(
                                      ontap: () {
                                        Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                              builder: (context) => DetailPage(
                                                imgUrl: electricProfiles[index]
                                                        ["profilePic"]
                                                    .toString(),
                                                name: electricProfiles[index]
                                                    ["name"],
                                                rating:
                                                    "${electricProfiles[index]["rating"]}",
                                                price: electricProfiles[index]
                                                    ["hourlyPrice"],
                                                allDetails: electricProfiles[index],
                                              ),
                                            ));
                                      },
                                      imgPath: electricProfiles[index]["profilePic"],
                                      name: electricProfiles[index]["name"],
                                      profession: electricProfiles[index]
                                          ["category"],
                                      price: electricProfiles[index]["hourlyPrice"],
                                      ratting:
                                          "${electricProfiles[index]["rating"]}",
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
          );
        },
      ),
    );
  }
}
