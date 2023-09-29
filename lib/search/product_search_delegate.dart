import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nati_project/home/home_page.dart';
import 'package:nati_project/home/model/product.dart';

import 'controllers/search_provider.dart';

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
    log('Refreshing');
    return FutureBuilder<List<Product>>(
      future: ref.read(searchProvider.notifier).searchFromAlgolia(searchTerm),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator.adaptive();
        }

        if (snapshot.hasError) {
          return Text(snapshot.error!.toString());
        }

        final data = snapshot.data;

        return ListView(
          children: [for (var p in data!) ProductTile(product: p)],
        );
      },
    );
  }
}
