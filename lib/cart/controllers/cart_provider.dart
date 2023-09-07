import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nati_project/home/model/product.dart';

final cartProvider = StateProvider<List<Product>>((ref) {
  // 0xghgffdsjhbkjnjnoht86tk
  return [];
});

final priceProvider= StateProvider<double>((ref){
  return 0;

});
