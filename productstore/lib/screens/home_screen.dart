import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth/auth_cubit.dart';
import '../blocs/home/home_cubit.dart';
import '../blocs/home/home_state.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/product_grid_item.dart';
import '../widgets/product_list_item.dart';
import '../widgets/product_loading_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isGridView = true;
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    final homeCubit = context.read<HomeCubit>();
    final state = context.watch<HomeCubit>().state;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Qargo'),
        elevation: 2,
        actions: [
          IconButton(
            icon: Icon(_showFilters ? Icons.filter_alt_off : Icons.filter_alt),
            tooltip: _showFilters ? 'Hide Filters' : 'Show Filters',
            onPressed: () => setState(() => _showFilters = !_showFilters),
          ),
          IconButton(
            icon: Icon(isGridView ? Icons.list : Icons.grid_view),
            tooltip: isGridView ? 'List View' : 'Grid View',
            onPressed: () => setState(() => isGridView = !isGridView),
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
        ],
      ),
      drawer: CustomDrawer(userId: authState.userId),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFE0F7FA), Color(0xFFB2EBF2)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              if (_showFilters)
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    children: [
                      DropdownButton<String?>(
                        hint: const Text('Sort By'),
                        value: state.sortOption ?? 'none',
                        borderRadius: BorderRadius.circular(12),
                        items: const [
                          DropdownMenuItem(value: 'none', child: Text('None')),
                          DropdownMenuItem(value: 'price_asc', child: Text('Price: Low to High')),
                          DropdownMenuItem(value: 'price_desc', child: Text('Price: High to Low')),
                          DropdownMenuItem(value: 'title_asc', child: Text('Title: A to Z')),
                          DropdownMenuItem(value: 'title_desc', child: Text('Title: Z to A')),
                        ],
                        onChanged: (value) => homeCubit.setSortOption(value),
                      ),
                      DropdownButton<String?>(
                        hint: const Text('Category'),
                        value: state.selectedCategory ?? 'All',
                        borderRadius: BorderRadius.circular(12),
                        items: [
                          const DropdownMenuItem(value: 'All', child: Text('All')),
                          ...state.allProducts
                              .map((p) => p.category)
                              .toSet()
                              .map((category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ))
                              .toList(),
                        ],
                        onChanged: (value) => homeCubit.filterByCategory(value),
                      ),

                    ],
                  ),
                ),
              Expanded(
                child: Builder(
                  builder: (_) {
                    if (state.isLoading) {
                      return const ProductShimmerGrid();
                    }

                    final products = state.visibleProducts;

                    if (products.isEmpty) {
                      return const Center(
                        child: Text(
                          'No products found.',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      );
                    }

                    return isGridView
                        ? GridView.builder(
                      padding: const EdgeInsets.all(12),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: products.length,
                      itemBuilder: (_, index) =>
                          ProductGridItem(product: products[index]),
                    )
                        : ListView.separated(
                      padding: const EdgeInsets.all(12),
                      itemCount: products.length,
                      separatorBuilder: (_, __) => const Divider(height: 16),
                      itemBuilder: (_, index) =>
                          ProductListItem(product: products[index]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
