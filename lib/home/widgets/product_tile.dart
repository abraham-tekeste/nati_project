import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nati_project/cart/model/cart_product.dart';

import '../../cart/controllers/cart_provider.dart';
import '../constants/colors.dart';
import '../model/product.dart';

class ProductTile extends ConsumerWidget {
  const ProductTile({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context, ref) {
    final isFavorite = ref.watch(isSelectedAsFavouriteProvider(product.id));

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: tdBGColor,
      elevation: 5,
      margin: const EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  ref.read(favoritesProvider.notifier).handleFavSelect(product);
                },
                icon: isFavorite
                    ? const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      )
                    : const Icon(
                        Icons.favorite_border_outlined,
                        color: Colors.red,
                      ),
              )
            ],
          ),
          Container(
            width: 200,
            height: 61,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: Image.network(product.thumbnail).image,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            product.name,
            style: const TextStyle(fontSize: 16),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  "${product.priceValue}",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              IconButton(
                onPressed: () async {
                  // ref.read(cartProvider.notifier).state = {
                  //   ...ref.read(cartProvider.notifier).state
                  //     ..add(CartProduct(product: product, quantity: 1))
                  // };
                  //FirebaseFirestore.instance.collection("cart").doc(product.id);
                  //log(product.id);
                  // print("inside icon button");
                  // print(product.id);

                  try {
                    await createProductToFirebase(product);
                  } on Exception catch (e) {
                    print(e);
                    // TODO
                  }

                  //FirebaseFirestore.instance.collection("cart").doc().
                },
                icon: const Icon(
                  Icons.add_shopping_cart_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Future createProductToFirebase(Product product) async {
  // final documentInCart =
  // FirebaseFirestore.instance.collection("cart").doc(id).get;

  final cartProduct = CartProduct(product: product, quantity: 1).toFireStore();
  FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('cart')
      .doc(product.id)
      .set(cartProduct, SetOptions(merge: true));
}
