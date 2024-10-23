import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_services/_DB%20services/Repositories/order_repo.dart';
import 'package:home_services/_DB%20services/bloc/order_cubit/orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit() : super(OrdersInitial());
  OrderRepo orderRepo = OrderRepo();
  Future<void> createOrder({
    required String orderId,
    required String userId,
    required String productId,
    required int quantity,
    required double price,
    required String shippingAddress,
    required String paymentMethod,
    required String status,
    required DateTime orderDate,
  }) async {
    emit(OrdersLoading());
    try {
      await orderRepo.createOrder(
        orderId: orderId,
        userId: userId,
        productId: productId,
        quantity: quantity,
        price: price,
        shippingAddress: shippingAddress,
        paymentMethod: paymentMethod,
        status: status,
        orderDate: orderDate,
      );
      emit(OrdersCreatedSuccess());
    } on Exception catch (e) {
      emit(OrdersErrorState(errorMessage: e.toString()));
    }
  }
}
