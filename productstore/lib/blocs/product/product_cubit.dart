import 'package:bloc/bloc.dart';
import 'package:productstore/blocs/product/product_state.dart';
import '../../repositories/product_repository.dart';


class ProductCubit extends Cubit<ProductState> {
  final ProductRepository repository;
  ProductCubit(this.repository) : super(ProductLoading());

  Future<void> fetchProducts() async {
    try {
      final products = await repository.fetchProducts();
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError('Failed to load products'));
    }
  }
}
