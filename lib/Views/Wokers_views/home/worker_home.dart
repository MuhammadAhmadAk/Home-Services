import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_services/Utils/Components/worker_drawer.dart';
import 'package:home_services/Utils/constants/colors.dart';
import 'package:home_services/Views/Wokers_views/components/pending_services_card.dart';
import 'package:home_services/models/user_model.dart';
import '../../../_DB services/SharedPref services/sharedpref_auth.dart';

class WorkerHomeScreen extends StatefulWidget {
  const WorkerHomeScreen({super.key});

  @override
  State<WorkerHomeScreen> createState() => _WorkerHomeScreenState();
}

class _WorkerHomeScreenState extends State<WorkerHomeScreen>
    with SingleTickerProviderStateMixin {
  UserModel? userModel;
  int totalCompletedServices = 0; // Replace with actual data
  double totalPaymentReceived = 0.0; // Replace with actual data

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    getUserData();
    getServiceData(); // Fetching service data

    // Animation setup
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Start the animation
    _controller.forward();
  }

  Future<void> getUserData() async {
    UserModel? _userModel = await SharedPrefAuth.getUser();
    setState(() {
      userModel = _userModel;
    });
  }

  Future<void> getServiceData() async {
    setState(() {
      // Update with fetched values
      totalCompletedServices = 5; // Sample data
      totalPaymentReceived = 150.0; // Sample data
    });
  }

  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (userModel == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: const Text('Worker Dashboard'),
        actions: <Widget>[],
      ),
      drawer: WorkerDrawer(
        user: userModel!,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: FadeTransition(
                opacity: _animation,
                child: GridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 2, // Number of columns
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  children: [
                    _buildAnimatedDashboardCard(
                      title: 'Total Completed Services',
                      value: totalCompletedServices.toString(),
                      icon: Icons.check_circle,
                      color: Colors.deepPurple,
                    ),
                    _buildAnimatedDashboardCard(
                      title: 'Total Payment Received',
                      value: '\$${totalPaymentReceived.toStringAsFixed(2)}',
                      icon: Icons.money,
                      color: Colors.teal,
                    ),
                    _buildAnimatedDashboardCard(
                      title: 'Pending Services',
                      value: '3', // Sample data
                      icon: Icons.hourglass_empty,
                      color: Colors.orange,
                    ),
                    _buildAnimatedDashboardCard(
                      title: 'Customer Feedback',
                      value: '4.5 ⭐', // Sample data
                      icon: Icons.star,
                      color: Colors.amber,
                    ),
                    // Add more cards as needed
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.0),
            // Add more widgets as needed
            Text(
              'Pending Services',
              style: TextStyle(
                  color: AppColors.appColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600),
            ),
            PendingServicesCard()
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedDashboardCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () {
        // Animation on tap
        _controller.forward(from: 0.0);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.white),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
