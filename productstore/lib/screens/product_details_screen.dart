import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../models/product_model.dart';

class ProductDetailsScreen extends StatelessWidget {
  final ProductModel product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(product.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFE0F7FA), Color(0xFFB2EBF2)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Product Image
                CachedNetworkImage(
                  imageUrl: product.thumbnail,
                  placeholder: (context, url) =>
                      Container(height: 250, color: Colors.grey[300]),
                  errorWidget: (context, url, error) =>
                  const Icon(Icons.error, size: 100),
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),

                // Title & Price
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.title,
                          style: theme.textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          )),
                      const SizedBox(height: 8),
                      Text("\$${product.price}",
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.green)),
                      const SizedBox(height: 8),
                      if (product.rating != null)
                        Row(
                          children: [
                            RatingBarIndicator(
                              rating: product.rating!,
                              itemCount: 5,
                              itemSize: 20,
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text("(${product.rating})"),
                          ],
                        ),
                    ],
                  ),
                ),

                // Description & Specs
                const SizedBox(height: 10),
                _sectionCard(
                  title: "Product Description",
                  children: [
                    Text(product.description,
                        style: theme.textTheme.bodyMedium),
                  ],
                ),

                _sectionCard(
                  title: "Specifications",
                  children: [
                    _specRow("Category", product.category),
                    _specRow("Brand", product.brand),
                    _specRow("Stock", product.stock?.toString()),
                    _specRow("SKU", product.sku),
                    _specRow("Weight", "${product.weight ?? '-'} g"),
                    if (product.dimensions != null) ...[
                      const SizedBox(height: 8),
                      Text("Dimensions", style: theme.textTheme.titleSmall),
                      _specRow("Width", "${product.dimensions!.width} cm"),
                      _specRow("Height", "${product.dimensions!.height} cm"),
                      _specRow("Depth", "${product.dimensions!.depth} cm"),
                    ]
                  ],
                ),

                if (product.meta != null)
                  _sectionCard(
                    title: "Meta Info",
                    children: [
                      _specRow("Created At", product.meta!.createdAt),
                      _specRow("Barcode", product.meta!.barcode),
                      const SizedBox(height: 8),
                      Text("QR Code", style: theme.textTheme.titleSmall),
                      const SizedBox(height: 8),
                      CachedNetworkImage(
                        imageUrl: product.meta!.qrCode,
                        height: 100,
                        placeholder: (context, url) => Container(
                          height: 100,
                          width: 100,
                          color: Colors.grey[300],
                        ),
                      )
                    ],
                  ),

                _sectionCard(
                  title: "Order Info",
                  children: [
                    _specRow("Warranty", product.warrantyInformation),
                    _specRow("Shipping", product.shippingInformation),
                    _specRow("Return Policy", product.returnPolicy),
                    _specRow("Min. Order", product.minimumOrderQuantity?.toString())
                  ],
                ),

                if (product.reviews?.isNotEmpty ?? false)
                  _sectionCard(
                    title: "Customer Reviews",
                    children: product.reviews!
                        .map(
                          (review) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RatingBarIndicator(
                            rating: review.rating,
                            itemCount: 5,
                            itemSize: 18,
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            review.comment,
                            style: theme.textTheme.bodyMedium,
                          ),
                          Text("- ${review.reviewerName}",
                              style: theme.textTheme.bodySmall!
                                  .copyWith(color: Colors.grey[600])),
                          const Divider(),
                        ],
                      ),
                    )
                        .toList(),
                  ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionCard({required String title, required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  Widget _specRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text("$label: ",
              style: const TextStyle(fontWeight: FontWeight.w600)),
          Expanded(child: Text(value ?? 'N/A')),
        ],
      ),
    );
  }
}
