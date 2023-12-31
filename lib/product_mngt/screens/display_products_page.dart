import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../home/controllers/products_provider.dart';
import '../../home/widgets/product_tile.dart';

class DisplayProductsPage extends ConsumerWidget {
  const DisplayProductsPage(this.id, this.name, {super.key});

  final String id;
  final String name;

  @override
  Widget build(BuildContext context, ref) {
    final productsAsync = ref.watch(categoryProductsProvider(id));
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          //leading: IconButton(onPressed: Navigator.of(context).pop(context), icon: const Icon(Icons.arrow_back),),
          title: Text(name),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              productsAsync.when(data: (products) {
                return Column(
                  children: products
                      .map((product) => ProductTile(product: product))
                      .toList(),
                );
              }, error: (e, s) {
                return Text("$e");
              }, loading: () {
                return const CircularProgressIndicator();
              })
            ],
          ),
        ));
  }
}
