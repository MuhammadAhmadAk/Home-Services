import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_services/Views/Wokers_views/components/booking_card.dart';
import 'package:home_services/_DB%20services/SharedPref%20services/shared_pref_worker_booking.dart';
import 'package:home_services/_DB%20services/bloc/booking%20cubit/booking_cubit.dart';

import '../../_DB services/Repositories/booking_repo.dart';
import '../../_DB services/bloc/booking cubit/booking_state.dart';
import '../booking/worker_card.dart';

class BookingRequests extends StatefulWidget {
  const BookingRequests({super.key});

  @override
  State<BookingRequests> createState() => _BookingRequestsState();
}

class _BookingRequestsState extends State<BookingRequests> {
  List<Map<String, dynamic>> _bookings = [];
  BookingRepository bookingRepository = new BookingRepository();

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    List<Map<String, dynamic>> savedbookings =
        await SharedprefWokerBookings.getWorkerBooking();
    String id = FirebaseAuth.instance.currentUser!.uid;

    if (savedbookings.isNotEmpty) {
      setState(() {
        _bookings = savedbookings;
      });
    }
    context.read<BookingCubit>().getAllWorkerBooking(id);
  }

  saveBookings(List<Map<String, dynamic>> bookings) async {
    await SharedprefWokerBookings.storeWorkerBooking(bookings);
    setState(() {
      _bookings = bookings;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Work Requests"),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: BlocConsumer<BookingCubit, BookingState>(
        listener: (context, state) {
          log("${state}");
          if (state is BookingFetchingState) {
            // log("${state.bookings}");
            saveBookings(state.bookings);
          }
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
                      log("Booking: ${booking["bookingId"]}");

                      return (booking["isAvailable"] == false)
                          ? BookingCard(
                              bookingData: booking,
                              onApprove: () async {
                                await bookingRepository
                                    .updateAvailabilityStatus(
                                        bookingId: booking["bookingId"],
                                        isAvailable: true);
                              },
                            )
                          : Container();
                    },
                  ),
          );
        },
      ),
    );
  }
}
