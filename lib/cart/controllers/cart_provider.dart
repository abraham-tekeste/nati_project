import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nati_project/home/model/product.dart';

final cartProvider = StateProvider<List<Product>>((ref) {
  return [];
});

final favouritesProvider = StateProvider<List<Product>>((ref) {
  return [];
});

final priceProvider = StateProvider<double>((ref) {
  return 0;
});

// final arekiCounterProvider = StateProvider<double>((ref) {
//   return 0;
// });
//
// final kognachCounterProvider = StateProvider<double>((ref) {
//   return 0;
// });
//
// final arekiNayAsmaraCounterProvider = StateProvider<double>((ref) {
//   return 0;
// });
//
// final jinCounterProvider = StateProvider<double>((ref) {
//   return 0;
// });


