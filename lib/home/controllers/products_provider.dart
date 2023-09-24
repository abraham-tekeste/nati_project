import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../categories_mngmt/models/category_model.dart';
import '../model/product.dart';

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
