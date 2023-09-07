import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/product.dart';

final productsProvider = FutureProvider<List<Product>>((ref) async {
  await Future.delayed(const Duration(seconds: 1));
  return [
    Product(
        id: '1',
        name: 'Areki',
        price: 120,
        image:"lib/assets/images/areki.jpeg"),
    Product(
        id: '2',
        name: 'Kognach',
        price: 110,
        image:"lib/assets/images/areki.jpeg"),
    Product(
        id: '12',
        name: 'Areki Nay Asmara',
        price: 200,
        image:"lib/assets/images/areki.jpeg"),
    Product(
        id: '23',
        name: 'Jin',
        price: 100,
        image:
            "lib/assets/images/areki.jpeg"),
  ];
});
