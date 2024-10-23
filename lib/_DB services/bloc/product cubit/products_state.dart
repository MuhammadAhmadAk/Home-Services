class ProductsState {}

final class ProductsInitial extends ProductsState {}

class ProductsLoading extends ProductsState {}

class ProductLoadedState extends ProductsState {
  final List<Map<String, dynamic>> products;
  ProductLoadedState({required this.products});
}

class ProductsError extends ProductsState {
  final String errorMessage;
  ProductsError({required this.errorMessage});
}
