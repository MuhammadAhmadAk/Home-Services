import 'dart:math';
import "dart:developer" as dev;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_services/Utils/constants/colors.dart';
import 'package:home_services/Views/shop/orders/order_success.dart';
import 'package:home_services/_DB%20services/bloc/order_cubit/orders_cubit.dart';
import 'package:home_services/_DB%20services/bloc/order_cubit/orders_state.dart';

class SingleOrderCheckoutPage extends StatefulWidget {
  final String itemName;
  final double itemPrice;
  final String itemImage; // Added image parameter
  final String productId;

  SingleOrderCheckoutPage({
    required this.itemName,
    required this.itemPrice,
    required this.itemImage,
    required this.productId, // Initialize image in the constructor
  });

  @override
  _SingleOrderCheckoutPageState createState() =>
      _SingleOrderCheckoutPageState();
}

class _SingleOrderCheckoutPageState extends State<SingleOrderCheckoutPage>
    with TickerProviderStateMixin {
  int _quantity = 1;
  String _selectedPaymentMethod = 'Credit Card'; // Default payment method
  String _shippingAddress = ''; // Shipping address value
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  final List<String> _paymentMethods = [
    'Credit Card',
    'EasyPaisa',
    'Cash on Delivery',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 1.1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String generateRandomTenDigitNumber() {
    Random random = Random();

    // Generate a 10-digit number, ensuring the first digit is not zero
    String number = (random.nextInt(9) + 1).toString(); // First digit (1-9)

    for (int i = 0; i < 9; i++) {
      number += random.nextInt(10).toString(); // Remaining digits (0-9)
    }

    return number;
  }

  double get _total => _quantity * widget.itemPrice;

  void _confirmOrder() {
    final userId =
        FirebaseAuth.instance.currentUser!.uid; // Replace with actual user ID
    if (_shippingAddress.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a shipping address.')),
      );
      return;
    }
    Map<String, dynamic> data = {
      'productId': widget.productId,
      'itemName': widget.itemName,
      'itemPrice': widget.itemPrice,
      'quantity': _quantity,
      'total': _total,
      'paymentMethod': _selectedPaymentMethod,
      'shippingAddress': _shippingAddress,
    };
    dev.log("$data");
    _controller.forward().then((_) {
      context.read<OrdersCubit>().createOrder(
          orderId: generateRandomTenDigitNumber(),
          userId: userId,
          productId: widget.productId,
          quantity: _quantity,
          price: widget.itemPrice,
          shippingAddress: _shippingAddress,
          paymentMethod: _selectedPaymentMethod,
          status: "pending",
          orderDate: DateTime.now());
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Order Confirmed!')));
      _controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appColor,
        iconTheme: Theme.of(context).primaryIconTheme,
        title: Text(
          'Checkout',
          style: GoogleFonts.poppins(fontSize: 18, color: AppColors.whiteColor),
        ),
      ),
      body: BlocConsumer<OrdersCubit, OrdersState>(
        listener: (context, state) {
          if (state is OrdersCreatedSuccess) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderSuccessfulScreen(
                      itemName: widget.itemName,
                      itemPrice: widget.itemPrice,
                      quantity: _quantity),
                ));
          } else {}

          // TODO: implement listener
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Item Details',
                  style: GoogleFonts.poppins(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                _buildProductImage(),
                SizedBox(height: 10),
                Text(widget.itemName, style: GoogleFonts.poppins(fontSize: 20)),
                SizedBox(height: 5),
                Text('\$${widget.itemPrice.toStringAsFixed(2)}',
                    style: GoogleFonts.poppins(fontSize: 20)),
                SizedBox(height: 20),
                _buildQuantityCounter(),
                SizedBox(height: 20),
                Divider(),
                _buildPaymentMethodDropdown(),
                SizedBox(height: 20),
                _buildShippingAddressField(),
                SizedBox(height: 20),
                Divider(),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'Total: \$${_total.toStringAsFixed(2)}',
                    style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
                (state is OrdersLoading)
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : GestureDetector(
                        onTap: _confirmOrder,
                        child: ScaleTransition(
                          scale: _scaleAnimation,
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.appColor,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black54,
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            padding: EdgeInsets.symmetric(vertical: 16),
                            alignment: Alignment.center,
                            child: Text(
                              'Confirm Order',
                              style: GoogleFonts.poppins(
                                  fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        widget.itemImage,
        height: 200, // Set the height for the product image
        width: double.infinity, // Make it full width
        fit: BoxFit.cover, // Maintain aspect ratio
      ),
    );
  }

  Widget _buildQuantityCounter() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 5,
            spreadRadius: 2,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: EdgeInsets.all(15.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              if (_quantity > 1) {
                setState(() {
                  _quantity--;
                });
              }
            },
            child: _buildCounterButton('-', _quantity > 1),
          ),
          SizedBox(width: 15.0),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$_quantity',
              style: GoogleFonts.poppins(
                  fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(width: 15.0),
          GestureDetector(
            onTap: () {
              setState(() {
                _quantity++;
              });
            },
            child: _buildCounterButton('+', true),
          ),
        ],
      ),
    );
  }

  Widget _buildCounterButton(String label, bool isEnabled) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: isEnabled ? Colors.black : Colors.grey,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          label,
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Method',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        DropdownButton<String>(
          value: _selectedPaymentMethod,
          isExpanded: true,
          items: _paymentMethods.map((method) {
            return DropdownMenuItem<String>(
              value: method,
              child: Text(
                method,
                style: GoogleFonts.poppins(fontSize: 16),
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedPaymentMethod = value!;
            });
          },
        ),
      ],
    );
  }

  Widget _buildShippingAddressField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Shipping Address',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        TextField(
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Enter your shipping address',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onChanged: (value) {
            setState(() {
              _shippingAddress = value;
            });
          },
        ),
      ],
    );
  }
}
