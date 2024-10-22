class BookingState {}

final class BookingInitial extends BookingState {}

final class BookingLoadingState extends BookingState {}

final class BookingConfirmedState extends BookingState {}

final class BookingFetchingState extends BookingState {
  final List<Map<String, dynamic>> bookings;
  BookingFetchingState({required this.bookings});
}

final class BookingErrorState extends BookingState {
  final String errorMessage;

  BookingErrorState(this.errorMessage);
}
