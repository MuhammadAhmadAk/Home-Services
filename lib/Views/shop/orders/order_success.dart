import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_services/Utils/constants/colors.dart';
import 'package:home_services/Views/bottom_navbar.dart';

class OrderSuccessfulScreen extends StatelessWidget {
  final String itemName;
  final double itemPrice;
  final int quantity;

  OrderSuccessfulScreen({
    required this.itemName,
    required this.itemPrice,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Order Successful',
          style: GoogleFonts.poppins(color: AppColors.whiteColor),
        ),
        iconTheme: Theme.of(context).primaryIconTheme,
        backgroundColor: AppColors.appColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 100,
            ),
            SizedBox(height: 20),
            Text(
              'Your order has been placed successfully!',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            _buildOrderSummary(),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => CustomNavbar(),
                ));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Continue Shopping',
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 4,
            spreadRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style:
                GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            '$quantity x $itemName',
            style: GoogleFonts.poppins(fontSize: 16),
          ),
          SizedBox(height: 5),
          Text(
            'Total: \$${(itemPrice * quantity).toStringAsFixed(2)}',
            style:
                GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
