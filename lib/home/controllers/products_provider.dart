import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/product.dart';

final categoryProductsProvider =
    StreamNotifierProvider.family<CategoryNotifier, List<Product>, String?>(
        CategoryNotifier.new);

class CategoryNotifier extends FamilyStreamNotifier<List<Product>, String> {
  @override
  build(arg) {
    final query = arg == 'All'
        ? FirebaseFirestore.instance
            .collection('stripeProducts')
            .where('active', isEqualTo: true)
        : FirebaseFirestore.instance
            .collection('stripeProducts')
            .where('categoryId', isEqualTo: arg)
            .where('active', isEqualTo: true);

    return query.snapshots().map((s) {
      List<Product> products = [];

      for (var p in s.docs) {
        fetchProductPrice(p.id);
        products.add(Product.fromFireStore(p));
      }

      return products;
    });
  }

  void fetchProductPrice(String id) async {
    await FirebaseFirestore.instance
        .collection('stripeProducts')
        .doc(id)
        .collection('prices')
        .get()
        .then((pricesSnapshot) {
      if (pricesSnapshot.size >= 1) {
        final priceData = pricesSnapshot.docs.first.data();

        double price = double.tryParse('${priceData['unit_amount']}') ?? 0;

        // String? currency = priceData['currency'];

        if (price > 0) {
          log('Price: $price');
          final pIndex = state.asData?.value.indexWhere((e) => e.id == id);

          if (pIndex != null && pIndex >= 0) {
            final updatedProduct =
                state.asData!.value[pIndex].copyWith(price: price);

            state.asData!.value[pIndex] = updatedProduct;

            state = AsyncData([...state.asData!.value]);
          }
        }
      }
    }).catchError((e, s) {
      log(e.toString());
      log(s.toString());
    });
  }
}

final productsProvider = StreamProvider<List<Product>>((ref) {
  return FirebaseFirestore.instance
      .collection('stripeProducts')
      .snapshots()
      .map((s) => s.docs.map((d) => Product.fromFireStore(d)).toList());
});
