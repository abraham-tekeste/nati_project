import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nati_project/home/home_page.dart';
import 'package:nati_project/home/model/product.dart';

class ProductSearch extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [IconButton(onPressed: () {}, icon: const Icon(Icons.cancel))];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return SearchResults(query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}

class SearchResults extends ConsumerWidget {
  const SearchResults(this.searchTerm, {super.key});

  final String searchTerm;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchAsync = ref.watch(searchProvider(searchTerm));

    return searchAsync.when(
      data: (products) {
        return ListView(
          children: [for (var p in products) ProductTile(product: p)],
        );
      },
      error: (error, stackTrace) => Text(error.toString()),
      loading: () => const CircularProgressIndicator.adaptive(),
    );
  }
}

final searchProvider =
    FutureProvider.family<List<Product>, String>((ref, arg) async {
  final result = await FirebaseFirestore.instance
      .collection('products')
      .where('name', isEqualTo: arg)
      .get();

  return result.docs.map((e) => Product.fromFireStore(e)).toList();
});
