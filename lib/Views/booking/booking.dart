import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_services/Views/booking/worker_card.dart';
import 'package:home_services/_DB%20services/SharedPref%20services/sharedpref_bookings.dart';
import 'package:home_services/_DB%20services/bloc/booking%20cubit/booking_cubit.dart';
import 'package:home_services/_DB%20services/bloc/booking%20cubit/booking_state.dart';

import '../../_DB services/Repositories/booking_repo.dart'; // Update with the actual package name

class BookingScreen extends StatefulWidget {
  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  List<Map<String, dynamic>> _bookings = [];

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    List<Map<String, dynamic>> savedbookings =
        await SharedprefBookings.getUserBooking();

    if (savedbookings.isNotEmpty) {
      setState(() {
        _bookings = savedbookings;
      });
    }
    context.read<BookingCubit>().getAllUserBooking();
  }

  saveBookings(List<Map<String, dynamic>> bookings) async {
    await SharedprefBookings.storeUserBooking(bookings);
    setState(() {
      _bookings = bookings;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Booked Services"),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: BlocConsumer<BookingCubit, BookingState>(
        listener: (context, state) {
          log("${state}");
          if (state is BookingFetchingState) {
            log("${state.bookings}");
            saveBookings(state.bookings);
          }
          // TODO: implement listener
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: _bookings.isEmpty
                ? Center(child: Text("No bookings found."))
                : ListView.builder(
                    itemCount: _bookings.length,
                    itemBuilder: (context, index) {
                      final booking = _bookings[index];

                      return WorkerCard(
                        onPayNowTap: () {},
                        isAvailable: booking['isAvailable'],
                        fullName: booking["worker"]['name'],
                        contactNumber: booking["worker"]['contactInfo'],
                        category: booking["worker"]['category'],
                        perHour: "${booking["worker"]['hourlyPrice']}\$",
                        imageUrl: booking["worker"]['profilePic'] ?? '',
                      );
                    },
                  ),
          );
        },
      ),
    );
  }
}
