import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nati_project/home/home_page.dart';
import 'package:nati_project/home/model/product.dart';
import 'package:typesense/typesense.dart';

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
  // final result = await FirebaseFirestore.instance
  //     .collection('products')
  //     .where('name', isEqualTo: arg)
  //     .get();

  // return result.docs.map((e) => Product.fromFireStore(e)).toList();

  Map<String, dynamic> convertKeysToStrings(Map<dynamic, dynamic> inputMap) {
    final Map<String, dynamic> newMap = {};
    inputMap.forEach((key, value) {
      if (value is Map) {
        value = convertKeysToStrings(value);
      }
      newMap[key.toString()] = value;
    });
    return newMap;
  }

  const host = '7ast3rl0dheoivqwp-1.a1.typesense.net',
      protocol = Protocol.https;

  final config = Configuration(
    // Api key
    '2o5x2pTdKzNBhyJR06qZxOEeD1IWpzar',
    nodes: {
      Node(
        protocol,
        host,
        // port: 7108,
      ),
      Node.withUri(
        Uri(
          scheme: 'https',
          host: host,
          // port: 8108,
        ),
      ),
      Node(
        protocol,
        host,

        // port: 9108,
      ),
    },
    numRetries: 3, // A total of 4 tries (1 original try + 3 retries)
    connectionTimeout: const Duration(seconds: 5),
  );

  final client = Client(config);

  final searchParameters = {
    'q': 'Verm',
    'query_by': 'name',
    // 'filter_by': 'num_employees:>100',
    // 'sort_by': 'num_employees:desc'
  };

  // var result = convertKeysToStrings(
  //     await client.collection('products').documents.search(searchParameters));
  var result=await client.collection('products').documents.search(searchParameters);
  //print("************************************");
  //log(json.decode(result.toString())['hits']);
  log(json.encode(result));

  final hits = json.decode(result.toString())['hits'];
  final products = hits.map((hit) => Product.fromFireStore(hit)).toList();
  return products;
    });
