import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/product.dart';

final productsProvider = FutureProvider<List<Product>>((ref) async {
  await Future.delayed(const Duration(seconds: 1));
  return [
    Product(
        id: '1',
        name: 'Areki',
        price: 120,
        image:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQtiP-IknqnsMwX_5o8OWI0TAbyD_xGReggaw&usqp=CAU'),
    Product(
        id: '2',
        name: 'Kognach',
        price: 110,
        image:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQtiP-IknqnsMwX_5o8OWI0TAbyD_xGReggaw&usqp=CAU'),
    Product(
        id: '12',
        name: 'Areki Nay Asmara',
        price: 200,
        image:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQtiP-IknqnsMwX_5o8OWI0TAbyD_xGReggaw&usqp=CAU'),
    Product(
        id: '23',
        name: 'Jin',
        price: 100,
        image:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQtiP-IknqnsMwX_5o8OWI0TAbyD_xGReggaw&usqp=CAU'),
  ];
});
