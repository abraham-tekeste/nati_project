import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../home/model/product.dart';
import 'controllers/cart_provider.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final cartProducts = ref.watch(cartProvider);

    log('Loading');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ...cartProducts.map((e) => CartProductTile(e)).toList(),
          ],
        ),
      ),
    );
  }
}

class CartProductTile extends ConsumerWidget {
  const CartProductTile(this.product, {super.key});

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
          onPressed: () async {
            // final old = ref.read(cartProvider);

            // List<Product> newProducts = [];

            // for (var element in old) {
            //   if (element.id != product.id) newProducts.add(element);
            // }

            // ref.read(cartProvider.notifier).state = newProducts;

            ref.read(cartProvider.notifier).state = [
              ...ref.read(cartProvider.notifier).state
                ..removeWhere((element) {
                  return element.id == product.id;
                })
            ];
          },
          icon: const Icon(Icons.remove),
        ),
        tileColor: Theme.of(context).colorScheme.surfaceVariant,
      ),
    );
  }
}
