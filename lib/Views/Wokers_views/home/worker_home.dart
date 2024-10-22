import 'package:flutter/material.dart';
import 'package:home_services/Utils/Components/worker_drawer.dart';
import 'package:home_services/models/user_model.dart';

import '../../../_DB services/SharedPref services/sharedpref_auth.dart';

class WorkerHomeScreen extends StatefulWidget {
  const WorkerHomeScreen({super.key});

  @override
  State<WorkerHomeScreen> createState() => _WorkerHomeScreenState();
}

class _WorkerHomeScreenState extends State<WorkerHomeScreen> {
  @override
  void initState() {
    super.initState();
    getUserData();
  }

  UserModel? userModel;
  getUserData() async {
    UserModel? _userModel = await SharedPrefAuth.getUser();
    setState(() {
      userModel = _userModel;
    });
  }

  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    if (userModel == null) {
      return CircularProgressIndicator();
    }
    return Scaffold(
        key: _globalKey,
        appBar: AppBar(title: Text('Worker Home'), actions: <Widget>[]),
        drawer: WorkerDrawer(
          user: userModel!,
        ),
        body: Center(child: Text("Worker")));
  }
}
