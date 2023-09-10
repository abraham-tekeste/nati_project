import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/product.dart';

final productsProvider = FutureProvider<List<Product>>((ref) async {
  final data = await FirebaseFirestore.instance.collection('products').get();
  final result = data.docs.map((d) => Product.fromFireStore(d)).toList();

  ///--
  ///
  // final formObj = Product(name: 'name', price: 12, image: 'image');

  // await FirebaseFirestore.instance.collection('products').add(formObj.toFirestore());

  ///
  ///
  return result;
});
