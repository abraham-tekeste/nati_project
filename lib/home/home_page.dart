import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nati_project/cart/controllers/cart_provider.dart';
import 'package:nati_project/home/controllers/products_provider.dart';

import '../cart/cart_page.dart';
import 'model/product.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final productsAsyc = ref.watch(productsProvider);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const CartPage(),
              ));
            },
            icon: const Icon(Icons.shopping_cart),
          )
        ],
      ),
      body: Center(
        child: productsAsyc.when(
          data: (products) {
            return Column(
              children: products
                  .map(
                    (e) => ProductTile(
                      product: e,
                    ),
                  )
                  .toList(),
            );
          },
          error: (error, stackTrace) => Text(error.toString()),
          loading: () => const CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class ProductTile extends ConsumerWidget {
  const ProductTile({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context, ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: ListTile(
        leading: Image.network(product.image),
        title: Text(product.name),
        subtitle: Text(product.price.toString()),
        trailing: IconButton(
          onPressed: () {
            ref.read(cartProvider.notifier).state.add(product);
          },
          icon: const Icon(Icons.add),
        ),
        tileColor: Theme.of(context).colorScheme.surfaceVariant,
      ),
    );
  }
}
