import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../cart/controllers/cart_provider.dart';
import '../constants/colors.dart';
import '../model/product.dart';

class ProductTile extends ConsumerWidget {
  const ProductTile({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context, ref) {
    final isFavorite = ref.watch(isSelectedAsFavouriteProvider(product.id));

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: tdBGColor,
      elevation: 5,
      margin: const EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  ref.read(favoritesProvider.notifier).handleFavSelect(product);
                },
                icon: isFavorite
                    ? const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      )
                    : const Icon(
                        Icons.favorite_border_outlined,
                        color: Colors.red,
                      ),
              )
            ],
          ),
          Container(
            width: 200,
            height: 61,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: Image.network(product.thumbnail).image,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            product.name,
            style: const TextStyle(fontSize: 16),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  "${product.priceValue}",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              IconButton(
                onPressed: () {
                  ref.read(cartProvider.notifier).state.add(product);
                  //final priceT=ref.read(priceProvider);
                  ref.read(priceProvider.notifier).state += product.priceValue;
                  //print(ref.read(priceProvider.notifier).state);
                },
                icon: const Icon(
                  Icons.add_shopping_cart_outlined,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
