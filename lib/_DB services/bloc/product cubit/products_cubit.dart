import 'package:bloc/bloc.dart';
import 'package:home_services/_DB%20services/Repositories/product_repo.dart';
import 'package:meta/meta.dart';

import 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit() : super(ProductsInitial());
  ProductRepo productRepo = new ProductRepo();
  Future<void> fetchProducts() async {
    try {
      final products = await productRepo.fetchedProducts();
      emit(ProductLoadedState(products: products));
    } catch (e) {
      emit(ProductsError(errorMessage: e.toString()));
    }
  }
}
