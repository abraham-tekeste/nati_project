//import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nati_project/categories_mngmt/add_category_page.dart';
import 'package:nati_project/categories_mngmt/controllers/category_provider.dart';

class CategoryManagement extends ConsumerWidget {
  const CategoryManagement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Category Management"),
      ),
      body: SingleChildScrollView(
          child: categoriesAsync.when(data: (categories) {
        return Column(
          children: [
            for (var category in categories)
              ListTile(
                title: Text(category.name),
                trailing: IconButton(
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection("categories")
                        .doc(category.id)
                        .delete();
                  },
                  icon: const Icon(Icons.remove),
                ),
              ),
          ],
        );
      }, error: (e, s) {
        return Text("$e");
      }, loading: () {
        return const CircularProgressIndicator();
      })),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddCategoryPage(),
              ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
