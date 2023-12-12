import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nati_project/cart/controllers/cart_provider.dart';

import 'home/widgets/product_tile.dart';

class FavouritesPage extends ConsumerWidget {
  const FavouritesPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final favouritesProducts = ref.watch(favoritesProvider);

    //log('Loading');

    return Scaffold(
      // backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          'Favourites',
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          SizedBox(
            height: 600,
            child: GridView.builder(
              itemCount: favouritesProducts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 220,
              ),
              itemBuilder: (BuildContext context, int index) {
                return ProductTile(product: favouritesProducts[index]);
              },
            ),
          ),
        ]),
      ),
    );
  }
}
