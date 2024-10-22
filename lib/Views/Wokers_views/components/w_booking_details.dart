import 'package:flutter/material.dart';

class BookingDetailsPage extends StatefulWidget {
  final Map<String, dynamic> bookingData;

  const BookingDetailsPage({Key? key, required this.bookingData})
      : super(key: key);

  @override
  _BookingDetailsPageState createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends State<BookingDetailsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    // Call forward on the AnimationController
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Booking Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FadeTransition(
          opacity: _animation,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Full Booking Information",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 20),
                _buildDetailCard(
                  "Name",
                  widget.bookingData['full_name'],
                  Icons.person,
                  Colors.lightBlue.shade100,
                ),
                _buildDetailCard(
                  "Address",
                  widget.bookingData['address'],
                  Icons.home,
                  Colors.lightGreen.shade100,
                ),
                _buildDetailCard(
                  "Work Type",
                  widget.bookingData['work_type'],
                  Icons.work,
                  Colors.yellow.shade100,
                ),
                _buildDetailCard(
                  "Contact",
                  widget.bookingData['contact_number'],
                  Icons.phone,
                  Colors.orange.shade100,
                ),
                _buildDetailCard(
                  "Email",
                  widget.bookingData['email'],
                  Icons.email,
                  Colors.pink.shade100,
                ),
                _buildDetailCard(
                  "Start Time",
                  widget.bookingData['start_time'],
                  Icons.access_time,
                  Colors.teal.shade100,
                ),
                _buildDetailCard(
                  "End Time",
                  widget.bookingData['end_time'],
                  Icons.access_time,
                  Colors.deepPurple.shade100,
                ),
                _buildDetailCard(
                  "Created At",
                  widget.bookingData['createdAt'],
                  Icons.date_range,
                  Colors.grey.shade100,
                ),
                _buildDetailCard(
                  "Payment Method",
                  widget.bookingData['payment_method'],
                  Icons.payment,
                  Colors.blueGrey.shade100,
                ),
                _buildDetailCard(
                  "Location",
                  "Lat: ${widget.bookingData['locations']['lat']}, Lng: ${widget.bookingData['locations']['lng']}",
                  Icons.location_on,
                  Colors.red.shade100,
                ),
                const SizedBox(height: 80), // For spacing above the button
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: ScaleTransition(
        scale: Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
          ),
        ),
        child: FloatingActionButton(
          onPressed: () {
            // Implement approval logic
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Approve Booking'),
                  content: const Text('Do you want to approve this booking?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        // Handle approval logic here
                        Navigator.of(context).pop();
                      },
                      child: const Text('Approve'),
                    )
                  ],
                );
              },
            );
          },
          child: const Icon(Icons.check),
        ),
      ),
    );
  }

  Widget _buildDetailCard(
      String label, String value, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 3,
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).primaryColor),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
