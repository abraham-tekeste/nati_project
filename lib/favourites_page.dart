import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nati_project/cart/controllers/cart_provider.dart';
import 'package:nati_project/home/home_page.dart';

class FavouritesPage extends ConsumerWidget {
  const FavouritesPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final favouritesProducts = ref.watch(favouritesProvider);

    //log('Loading');

    return Scaffold(
      //backgroundColor: tdBGColor,
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          'Favourites',
          style: TextStyle(
              fontSize: 28.0, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          SizedBox(
            height: 600,
            child: GridView.builder(
              itemCount: favouritesProducts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
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
