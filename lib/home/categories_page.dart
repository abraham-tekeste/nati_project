import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nati_project/categories_mngmt/controllers/category_provider.dart';

import '../categories_mngmt/models/category_model.dart';
import '../product_mngt/screens/display_products_page.dart';

class CategoriesPage extends ConsumerWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    //final productsAsyc = ref.watch(productsProvider);
    final categoryAsync = ref.watch(categoriesProvider);
    //final totalPrices=ref.watch(priceProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: const Text(
          "Categories",
          style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
        ),
        //backgroundColor: tdBGColor,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              height: 500,
              decoration: const BoxDecoration(
                color: Colors.white, //Color(0xFFFEF9EB),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    categoryAsync.when(data: (categories) {
                      return Column(
                        children: categories
                            .map((category) => CategoryTile(
                                  category: category,
                                ))
                            .toList(),
                      );
                    }, error: (e, s) {
                      return Text("$e");
                    }, loading: () {
                      return const CircularProgressIndicator();
                    })
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryTile extends ConsumerWidget {
  const CategoryTile({super.key, required this.category});

  final Category category;

  @override
  Widget build(BuildContext context, ref) {
    return Container(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: ListTile(
        leading: const CircleAvatar(
            backgroundImage: AssetImage("assets/images/areki.jpeg")),
        title: Text(category.name),
        subtitle: const Text("This many ads available"),
        trailing: const Icon(Icons.navigate_next),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    DisplayProductsPage(category.id, category.name),
              ));
        },
        //IconButton(
        //   onPressed: () {//print(ref.read(priceProvider.notifier).state);
        //   },
      ),
      //tileColor: Theme.of(context).colorScheme.surfaceVariant,
    );
  }
}
