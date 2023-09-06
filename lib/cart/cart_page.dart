import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nati_project/home/constants/colors.dart';

import '../home/model/product.dart';
import 'controllers/cart_provider.dart';

// this is comment for test github
class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final cartProducts = ref.watch(cartProvider);

    log('Loading');

    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: AppBar(
        backgroundColor: tdBGColor,
        title: const Text('Cart'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: List.generate(
            cartProducts.length,
            (i) => CartProductTile(cartProducts[i], i),
          ),
        ),
      ),
      persistentFooterButtons: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text("Total:"),
            const SizedBox(
              width: 100,
            ),
            Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.deepPurple.shade50),
                child: Text("${ref.read(priceProvider.notifier).state}")),
          ],
        ),
      ],
    );
  }
}

class CartProductTile extends ConsumerWidget {
  const CartProductTile(this.product, this.index, {super.key});

  final Product product;
  final int index;

  @override
  Widget build(BuildContext context, ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: ListTile(
        leading: Image.asset(product.image),
        title: Text(product.name),
        subtitle: Text(product.price.toString()),
        trailing: IconButton(
          onPressed: () async {
            ref.read(cartProvider.notifier).state = [
              ...ref.read(cartProvider.notifier).state..removeAt(index)
            ];

            ref.read(priceProvider.notifier).state -= product.price;
          },
          icon: const Icon(Icons.remove),
        ),
        //tileColor: Theme.of(context).colorScheme.surfaceVariant,
      ),
    );
  }
}
