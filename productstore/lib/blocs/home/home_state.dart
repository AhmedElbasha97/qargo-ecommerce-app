import '../../models/product_model.dart';

class HomeState {
  final List<ProductModel> allProducts;
  final List<ProductModel> visibleProducts;
  final String? selectedCategory;
  final String? sortOption;
  final bool isLoading;

  HomeState({
    required this.allProducts,
    required this.visibleProducts,
    this.selectedCategory,
    this.sortOption,
    this.isLoading = true,
  });

  HomeState copyWith({
    List<ProductModel>? allProducts,
    List<ProductModel>? visibleProducts,
    String? selectedCategory,
    String? sortOption,
    bool? isLoading,
  }) {
    return HomeState(
      allProducts: allProducts ?? this.allProducts,
      visibleProducts: visibleProducts ?? this.visibleProducts,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      sortOption: sortOption ?? this.sortOption,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
