import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nati_project/categories_mngmt/controllers/category_provider.dart';
import 'package:nati_project/home/controllers/products_provider.dart';
import 'package:nati_project/home/model/product.dart';

class ProdctsMngtPage extends ConsumerWidget {
  const ProdctsMngtPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final productsAsync = ref.watch(productsProvider);
    return Scaffold(
        body: productsAsync.when(
            data: (products) {
              return ListView.builder(
                itemCount: products.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(products[index].name),
                    subtitle: Text(products[index].price.toString()),
                    trailing: PopupMenuButton(
                      onSelected: (value) {
                        if (value == "set_category") {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) =>
                                  CategorySelector(id: products[index].id));
                        }
                      },
                      itemBuilder: (BuildContext context) {
                        return [
                          const PopupMenuItem(
                            value: "set_category",
                            child: Text("Set category"),
                          )
                        ];
                      },
                    ),
                  );
                },
              );
            },
            error: (error, stackTrace) => Text("$error"),
            loading: () {
              return const CircularProgressIndicator();
            }));
  }
}

class CategorySelector extends ConsumerWidget {
  const CategorySelector({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    return categoriesAsync.when(
        data: (categories) => ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) => ListTile(
                  title: Text(categories[index].name),
                  onTap: () {
                    FirebaseFirestore.instance
                        .collection("products")
                        .doc(id)
                        .update({
                      "categoryId": categories[index].id,
                    });
                    log(categories[index].id);
                  },
                )),
        error: (error, stackTrace) => Text("$error"),
        loading: () {
          return const CircularProgressIndicator();
        });
  }
}
