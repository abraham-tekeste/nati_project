import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nati_project/home/model/product.dart';

final cartProvider = StateProvider<List<Product>>((ref) {
  return [];
});

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
      state = [
        ...state,
        product,
      ];
    }
  }
}

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
