class OrdersState {}

final class OrdersInitial extends OrdersState {}

final class OrdersLoading extends OrdersState {}

final class OrdersCreatedSuccess extends OrdersState {}

final class OrdersErrorState extends OrdersState {
  final String errorMessage;
  OrdersErrorState({required this.errorMessage});
}
