import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../categories_mngmt/controllers/category_provider.dart';
import '../controllers/products_provider.dart';
import 'product_tile.dart';

class ProductsSection extends ConsumerWidget {
  const ProductsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategoryId = ref.watch(selectedCategoryProvider).id;
    final productAsync =
        ref.watch(categoryProductsProvider(selectedCategoryId));
    return productAsync.when(
      data: (products) => GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: 286,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ProductTile(product: products[index]);
        },
      ),
      error: (error, stackTrace) => Text("$error"),
      loading: () => const CircularProgressIndicator(),
    );
  }
}
