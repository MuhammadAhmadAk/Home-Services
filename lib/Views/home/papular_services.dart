import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Utils/Components/service_widget.dart';
import '../../_DB services/SharedPref services/shared_pref_workers_profiles.dart';
import '../../_DB services/bloc/worker-cubit/wokers_profile_cubit.dart';
import '../../_DB services/bloc/worker-cubit/wokers_profile_state.dart';
import '../Category/Pages/detailspage.dart';

class PapularServices extends StatefulWidget {
  const PapularServices({
    super.key,
  });

  @override
  State<PapularServices> createState() => _PapularServicesState();
}

class _PapularServicesState extends State<PapularServices>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> AllProfiles = [];

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
      AllProfiles = newProfiles;
    });
  }

  getProfiles() async {
    List<Map<String, dynamic>>? savedProfiles =
        await SharedPrefWorkerProfiles.getWorkerProfiles();
    log("All saved profiles $savedProfiles");
    if (savedProfiles != null) {
      setState(() {
        AllProfiles = savedProfiles;
      });
    }
    context.read<WokersProfileCubit>().getAllProfiles();
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
              return (AllProfiles.isEmpty)
                  ? Center(
                      child: Text("No Wokers Avalible"),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: AllProfiles.length,
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
                                                imgUrl: AllProfiles[index]
                                                        ["profilePic"]
                                                    .toString(),
                                                name: AllProfiles[index]
                                                    ["name"],
                                                rating:
                                                    "${AllProfiles[index]["rating"]}",
                                                price: AllProfiles[index]
                                                    ["hourlyPrice"],
                                                allDetails: AllProfiles[index],
                                              ),
                                            ));
                                      },
                                      imgPath: AllProfiles[index]["profilePic"],
                                      name: AllProfiles[index]["name"],
                                      profession: AllProfiles[index]
                                          ["category"],
                                      price: AllProfiles[index]["hourlyPrice"],
                                      ratting:
                                          "${AllProfiles[index]["rating"]}",
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
