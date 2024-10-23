import 'package:flutter/material.dart';
import 'package:home_services/Utils/Components/custom_button.dart';
import 'package:home_services/Utils/constants/colors.dart';

class BookingCard extends StatefulWidget {
  final Map<String, dynamic> bookingData;
  final VoidCallback onApprove;
  final VoidCallback onAddressView;

  const BookingCard({
    Key? key,
    required this.bookingData,
    required this.onApprove,
    required this.onAddressView,
  }) : super(key: key);

  @override
  _BookingCardState createState() => _BookingCardState();
}

class _BookingCardState extends State<BookingCard>
    with TickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _heightAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _heightAnimation = Tween<double>(begin: 0.0, end: 200.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      _isExpanded ? _controller.forward() : _controller.reverse();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleExpansion,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: _isExpanded ? AppColors.appColor : Colors.white,
          // gradient: LinearGradient(
          //   colors: [
          //     _isExpanded ? AppColors.appColor : Colors.white,
          //     _isExpanded ? Colors.lightBlueAccent : Colors.white,
          //   ],
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          // ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
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
                  color: _isExpanded
                      ? Colors.white
                      : Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 10),
              _buildInfoRow(Icons.person, "Name",
                  widget.bookingData['full_name'], context),
              _buildInfoRow(
                  Icons.work, "Work", widget.bookingData['work_type'], context),
              const Divider(height: 20, thickness: 2),
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                child: Container(
                  height: _isExpanded
                      ? null
                      : 0, // Height is dynamic based on expansion
                  child: Column(
                    children: [
                      _buildInfoRow(Icons.access_time, "Start Time",
                          widget.bookingData['start_time'], context),
                      _buildInfoRow(Icons.access_time, "End Time",
                          widget.bookingData['end_time'], context),
                      _buildInfoRow(Icons.payment, "Payment Method",
                          widget.bookingData['payment_method'], context),
                      _buildInfoRow(Icons.location_on, "Address",
                          widget.bookingData['address'], context),
                      const SizedBox(height: 10),
                      (widget.bookingData["isAvailable"] == true)
                          ? CustomButtonWidget(
                              buttonBackgroundColor: AppColors.whiteColor,
                              textColor: AppColors.appColor,
                              text: "View Address",
                              onPressed: widget.onAddressView)
                          : CustomButtonWidget(
                              buttonBackgroundColor: AppColors.whiteColor,
                              textColor: AppColors.appColor,
                              text: "Approve",
                              onPressed: widget.onApprove)
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: _isExpanded
                        ? Colors.white
                        : Theme.of(context).primaryColor,
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
          Icon(icon,
              color:
                  _isExpanded ? Colors.white : Theme.of(context).primaryColor),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "$label: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: _isExpanded ? Colors.white : Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: value,
                    style: TextStyle(
                      fontSize: 16,
                      color: _isExpanded ? Colors.white : Colors.black,
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
