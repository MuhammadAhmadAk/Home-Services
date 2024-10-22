import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_services/_DB%20services/Repositories/booking_repo.dart';
import 'package:home_services/_DB%20services/bloc/booking%20cubit/booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  BookingCubit() : super(BookingInitial());
  BookingRepository bookingRepository = BookingRepository();
  Future<void> createHireBook({
    required String fullName,
    required String contactNumber,
    required String email,
    required String workType,
    required String address,
    required String startTime,
    required String endTime,
    required Map<String, dynamic> locations,
    required String paymentMethod,
    required Map<String, dynamic>
        worker, // Optional: location ID for a single-location booking
  }) async {
    emit(BookingLoadingState());
    try {
      final booking = await bookingRepository.createHireBook(
        fullName: fullName,
        contactNumber: contactNumber,
        email: email,
        workType: workType,
        address: address,
        startTime: startTime,
        endTime: endTime,
        locations: locations,
        paymentMethod: paymentMethod,
        worker: worker,
      );
      emit(BookingConfirmedState());
    } on Exception catch (e) {
      emit(BookingErrorState(e.toString()));
    }
  }

  Future<void> getAllUserBooking() async {
    emit(BookingLoadingState());
    try {
      final bookings = await bookingRepository.getBookings();

      emit(BookingFetchingState(bookings: bookings));
    } on Exception catch (e) {
      emit(BookingErrorState(e.toString()));
    }
  }

  Future<void> getAllWorkerBooking(String workerId) async {
    emit(BookingLoadingState());
    try {
      final bookings = await bookingRepository.getWorkerBookings(workerId);

      emit(BookingFetchingState(bookings: bookings));
    } on Exception catch (e) {
      emit(BookingErrorState(e.toString()));
    }
  }
  
}
