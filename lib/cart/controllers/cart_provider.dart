import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nati_project/cart/cart_page.dart';
import 'package:nati_project/cart/model/cart_product.dart';
import 'package:nati_project/home/model/product.dart';

// final cartProvider = StateProvider<Set<CartProduct>>((ref) {
//   return {};
// });

// final cartProvider =
//     NotifierProvider<CartNotifier, Set<Product>>(CartNotifier.new);

final cartProvider =
    NotifierProvider<CartNotifier, Set<CartProduct>>(CartNotifier.new);

class CartNotifier extends Notifier<Set<CartProduct>> {
  @override
  build() {
    return {};
  }

  void addToSet(CartProduct c) {
    final index = state
        .toList()
        .indexWhere((element) => element.product.id == c.product.id);
    if (index == -1) {
      state = {...state, c};
    } else {
      state.elementAt(index).quantity = c.quantity;
      state = {...state};
    }
  }

  void removeCartProducts(String id) {
    final index =
        state.toList().indexWhere((element) => element.product.id == id);
    //print("index " + index.toString());
    state.remove(state.elementAt(index));

    state = {
      ...state
      // ..removeWhere((element) {
      //   print("${element.product.id}==$id:${element.product.id == id}");
      //   return element.product.id == id;
      // })
    };
    //print("after remove " + state.length.toString());
  }

  void makeOrder() async {
    final orderRef = await FirebaseFirestore.instance
        .collection("orders")
        .add({'userID': FirebaseAuth.instance.currentUser!.uid});
    final cartProductsRef = orderRef.collection("cartProducts");
    for (var c in state) {
      await cartProductsRef.doc(c.product.id).set(c.toFireStore());
    }
    for (var c in state) {
      FirebaseFirestore.instance
          .collection(FireStoreKeys.cartCollection)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("cartProducts")
          .doc(c.product.id)
          .delete();
    }
    state = {};
  }
}

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
  final cartProducts = ref.watch(cartProvider);

  double sum = 0;
  for (var e in cartProducts) {
    print(e.toString());
    sum = sum + e.product.priceValue * e.quantity;
  }
  //print("---" * 10);
  return sum;
});
