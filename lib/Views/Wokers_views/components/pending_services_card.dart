import 'package:flutter/material.dart';
import 'package:home_services/Utils/constants/colors.dart';

class PendingServicesCard extends StatefulWidget {
  const PendingServicesCard({super.key});

  @override
  State<PendingServicesCard> createState() => _PendingServicesCardState();
}

class _PendingServicesCardState extends State<PendingServicesCard>
    with TickerProviderStateMixin {
  bool _isExpanded = false;

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  void _toggleCard() {
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
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTap: _toggleCard,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: _isExpanded ? AppColors.appColor : Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pending Service Request',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _isExpanded ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Service Type: Cleaning',
                style: TextStyle(
                  color: _isExpanded ? Colors.white70 : Colors.grey[700],
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Request Date: ${DateTime.now().toLocal()}'.split(' ')[0],
                style: TextStyle(
                  color: _isExpanded ? Colors.white70 : Colors.grey[700],
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 300),
                firstChild: Container(),
                secondChild: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Details:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Additional details about the service request can go here.',
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        // Handle the action when the button is pressed
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('View More'),
                    ),
                  ],
                ),
                crossFadeState: _isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
