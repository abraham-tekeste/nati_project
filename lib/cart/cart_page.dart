//import 'dart:developer';

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cartProducts.length,
              itemBuilder: (context, i) {
                return CartProductTile(cartProducts[i], i);
              },
            ),
          ),
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.blue.shade50,
                ),
                constraints: const BoxConstraints(minHeight: 250),
                margin: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Order Details",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextInOrderDetails(
                              labelName: "Total items",
                              labelValue: cartProducts.length.toString()),
                          const TextInOrderDetails(
                              labelName: "Shipping Charges", labelValue: "0.0"),
                          const TextInOrderDetails(
                              labelName: "Total Tax", labelValue: "15%"),
                          TextInOrderDetails(
                              labelName: "Grand Total",
                              labelValue: ref
                                  .read(priceProvider.notifier)
                                  .state
                                  .toString()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(300, 48)),
                  child: const Text(
                    'Proceed to payment',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),

      // persistentFooterButtons: [
      //   Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //     children: [
      //       const Text("Total:"),
      //       const SizedBox(
      //         width: 100,
      //       ),
      //       Container(
      //           padding: const EdgeInsets.all(10),
      //           decoration: BoxDecoration(color: Colors.deepPurple.shade50),
      //           child: Text("${ref.read(priceProvider.notifier).state}")),
      //       ElevatedButton(
      //         onPressed: () {},
      //         child: const Text('Proceed to payment'),
      //       )
      //     ],
      //   ),
      // ],
    );
  }
}

class TextInOrderDetails extends StatelessWidget {
  const TextInOrderDetails({
    required this.labelName,
    required this.labelValue,
    super.key,
  });
  final String labelName;
  final String labelValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            labelName,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            labelValue,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          )
        ],
      ),
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
        //leading: Image.network(product.thumbnail),
        title: Text(product.name),
        subtitle: Text(product.price.toString()),
        trailing: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            // const IconButton(onPressed: null, icon: Icon(Icons.add)),
            IconButton(
              onPressed: () async {
                ref.read(cartProvider.notifier).state = [
                  ...ref.read(cartProvider.notifier).state..removeAt(index)
                ];

                ref.read(priceProvider.notifier).state -= product.price;
              },
              icon: const Icon(Icons.remove),
            ),
          ],
        ),
        //tileColor: Theme.of(context).colorScheme.surfaceVariant,
      ),
    );
  }
}
