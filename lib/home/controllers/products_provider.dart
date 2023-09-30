import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/product.dart';

final categoryProductsProvider =
    StreamProvider.family<List<Product>, String>((ref, arg) {
  return FirebaseFirestore.instance
      .collection('products')
      .where('categoryId', isEqualTo: arg)
      .snapshots()
      .map((s) => s.docs.map((d) => Product.fromFireStore(d)).toList());
});

final productsProvider = StreamProvider<List<Product>>((ref) {
  return FirebaseFirestore.instance
      .collection('products')
      .snapshots()
      .map((s) => s.docs.map((d) => Product.fromFireStore(d)).toList());
});








// final productsProvider = StreamProvider<List<Product>>((ref) async* {
//   await for (var data
//       in FirebaseFirestore.instance.collection('products').snapshots()) {
//     yield data.docs.map((d) => Product.fromFireStore(d)).toList();
//   }
// });
