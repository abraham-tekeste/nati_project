import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nati_project/cart/model/cart_product.dart';
import 'package:nati_project/home/model/product.dart';

// final cartProvider = StateProvider<Set<CartProduct>>((ref) {
//   return {};
// });

// final cartProvider =
//     NotifierProvider<CartNotifier, Set<Product>>(CartNotifier.new);

final cartProvider = StreamProvider<Set<CartProduct>>((ref) {
  return FirebaseFirestore.instance.collection("cart").snapshots().map((s) => s
      .docs
      .map((d) => CartProduct(product: Product.fromFireStore(d), quantity: 1))
      .toSet());
});

// class CartNotifier extends Notifier<Set<Product>> {
//   @override
//   build() {
//     final cartProducts = <Product>{};
//     final query = FirebaseFirestore.instance
//         .collection("cart")
//         .snapshots()
//         .map((s) => s.docs.map((d) => Product.fromFireStore(d)));

//     cartProducts.addAll(query as Iterable<Product>);
//     return cartProducts;
//   }
// }

// final favouritesProvider = StateProvider<List<Product>>((ref) {
//   return []; // 0xmdkmnklwlkeflkw [kdms, sndk]
// });

final isSelectedAsFavouriteProvider = StateProvider.family((ref, arg) {
  final favorites = ref.watch(favoritesProvider);

  return favorites.indexWhere((e) => e.id == arg) >= 0;
});

final favoritesProvider =
    NotifierProvider<FavoritesNotifier, List<Product>>(FavoritesNotifier.new);

class FavoritesNotifier extends Notifier<List<Product>> {
  @override
  build() {
    return [];
  }

  void handleFavSelect(Product product) {
    if (state.indexWhere((e) => e.id == product.id) >= 0) {
      state = [
        ...state..removeWhere((element) => element.id == product.id),
      ];
    } else {
      state = [...state, product];
    }
  }
}

final priceProvider = StateProvider<double>((ref) {
  final cartProductAsync = ref.watch(cartProvider);
  var cartProducts = <CartProduct>{};
  cartProductAsync.when(
    data: (cartProduct) {
      cartProducts = cartProduct;
    },
    error: (error, stackTrace) => Text("$error"),
    loading: () => const CircularProgressIndicator(),
  );

  double sum = 0;
  for (var e in cartProducts) {
    sum = sum + e.product.priceValue * e.quantity;
  }
  return sum;
});
