import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/product_model.dart';
import '../../repositories/product_repository.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final ProductRepository productRepository;

  HomeCubit(this.productRepository)
      : super(HomeState(allProducts: [], visibleProducts: []));

  Future<void> loadProducts() async {
    emit(state.copyWith(isLoading: true));
    final products = await productRepository.fetchProducts();
    emit(state.copyWith(
      allProducts: products,
      visibleProducts: products,
      isLoading: false,
    ));
  }

  void filterByCategory(String? category) {
    print('filterByCategory called with category: $category');
    final newCategory =  category;
    emit(state.copyWith(selectedCategory: newCategory));
    _applyFiltersAndSort();
  }

  void setSortOption(String? sortOption) {
    final newSort= sortOption;
    emit(state.copyWith(sortOption: newSort));
    _applyFiltersAndSort();
  }

  void _applyFiltersAndSort() {
    List<ProductModel> filtered = List.from(state.allProducts);

    // Apply category filter if selected
    if ( state.selectedCategory != 'All') {
      filtered = filtered
          .where((product) => product.category == state.selectedCategory)
          .toList();
    }

    // Apply sorting only if sortOption is set
    if ( state.sortOption != 'none') {
      switch (state.sortOption) {
        case 'price_asc':
          filtered.sort((a, b) => a.price.compareTo(b.price));
          break;
        case 'price_desc':
          filtered.sort((a, b) => b.price.compareTo(a.price));
          break;
        case 'title_asc':
          filtered.sort((a, b) => a.title.compareTo(b.title));
          break;
        case 'title_desc':
          filtered.sort((a, b) => b.title.compareTo(a.title));
          break;
      }
    }

    emit(state.copyWith(visibleProducts: filtered));
  }
}
