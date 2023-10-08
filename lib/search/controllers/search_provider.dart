import 'dart:developer';

import 'package:algoliasearch/algoliasearch.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../home/model/product.dart';

final searchProvider =
    NotifierProvider<SearchNotifier, void>(SearchNotifier.new);

class SearchNotifier extends Notifier<void> {
  late final SearchClient searchClient;

  late final List<Product> cache;

  @override
  build() async {
    log('Initiating constructor');
    searchClient = SearchClient(
      appId: 'QBJM532ELH',
      apiKey: '77f76722164033a5f9747a66e4214db6',
    );

    cache = [];

    return;
  }

  Future<List<Product>> searchFromAlgolia(String searchTerm) async {
    log('Searching $searchTerm');

    final resultFromCache = searchCache(searchTerm);

    // log('Returned from cache method');

    if (resultFromCache.isNotEmpty) {
      log('Search term found in cache');

      return resultFromCache;
    }

    final searchQuery = SearchForHits(
      indexName: 'products',
      query: searchTerm,
      hitsPerPage: 2,
    );

    // log('Searching algolia');

    final result = await searchClient.searchIndex(request: searchQuery);

    final resultFromAlgolia = result.hits
        .map(
          (hit) => Product(
            id: hit.objectID,
            name: hit['name'],
            price: double.tryParse('${hit['price']}') ?? 0,
            images: hit['image'],
          ),
        )
        .toList();

    cache.addAll(resultFromAlgolia);
    log('Added algolia results to cache');

    return resultFromAlgolia;
  }

  List<Product> searchCache(String searchTerm) {
    return cache.where((p) {
      return p.name.toLowerCase().contains(searchTerm.toLowerCase());
    }).toList();
  }
}
