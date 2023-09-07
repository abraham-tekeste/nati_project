import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nati_project/cart/controllers/cart_provider.dart';
import 'package:nati_project/home/controllers/products_provider.dart';

import '../cart/cart_page.dart';
import 'constants/colors.dart';
import 'model/product.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final productsAsyc = ref.watch(productsProvider);
    //final totalPrices=ref.watch(priceProvider);

    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: AppBar(
        backgroundColor: tdBGColor,
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
      body: Column(
        children: [
          searchBox(),
          const SizedBox(height: 10,),
          Center(
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
        ],
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
        leading: Image.asset(product.image),
        title: Text(product.name),
        subtitle: Text(product.price.toString()),
        trailing: IconButton(
          onPressed: () {
            ref.read(cartProvider.notifier).state.add(product);
            //final priceT=ref.read(priceProvider);
            ref.read(priceProvider.notifier).state=ref.read(priceProvider.notifier).state+product.price;
            //print(ref.read(priceProvider.notifier).state);
          },
          icon: const Icon(Icons.add),
        ),
        //tileColor: Theme.of(context).colorScheme.surfaceVariant,
      ),
    );
  }
}



Widget searchBox() {
  return Container(
    decoration: BoxDecoration(
        color: Colors.white70, borderRadius: BorderRadius.circular(20.0)),
    child:  const TextField(
      onChanged: null,
      decoration: InputDecoration(
          hintText: "search",
          prefixIcon: Icon(
            Icons.search,
            color: tdBlack,
            size: 20,
          ),
          border: InputBorder.none),
    ),
  );
}
//...cartProducts.map((e) => CartProductTile(e)).toList(),