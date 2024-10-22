import 'package:flutter/material.dart';
import 'package:home_services/Utils/Components/custom_button.dart';

class BookingCard extends StatefulWidget {
  final Map<String, dynamic> bookingData;
  final VoidCallback onApprove;

  const BookingCard(
      {Key? key, required this.bookingData, required this.onApprove})
      : super(key: key);

  @override
  _BookingCardState createState() => _BookingCardState();
}

class _BookingCardState extends State<BookingCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded; // Toggle expanded state
        });
      },
      child: Card(
        elevation: 8.0,
        margin: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Work Details",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 10),
              _buildInfoRow(Icons.person, "Name",
                  widget.bookingData['full_name'], context),
              _buildInfoRow(Icons.phone, "Work",
                  widget.bookingData['work_type'], context),
              const Divider(height: 20, thickness: 2),
              if (_isExpanded) ...[
                _buildInfoRow(Icons.access_time, "Start Time",
                    widget.bookingData['start_time'], context),
                _buildInfoRow(Icons.access_time, "End Time",
                    widget.bookingData['end_time'], context),
                _buildInfoRow(Icons.payment, "Payment Method",
                    widget.bookingData['payment_method'], context),
                _buildInfoRow(Icons.location_on, "Address",
                    widget.bookingData['address'], context),
                CustomButtonWidget(text: "Approve", onPressed: widget.onApprove)
              ],
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
      IconData icon, String label, String value, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).primaryColor),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "$label: ",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black, // Change to your desired text color
                    ),
                  ),
                  TextSpan(
                    text: value,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black, // Change to your desired text color
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
