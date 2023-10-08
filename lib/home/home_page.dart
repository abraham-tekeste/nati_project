import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../cart/cart_page.dart';
import '../categories_mngmt/models/category_model.dart';
import '../product_mngt/screens/display_products_page.dart';
import '../search/product_search_delegate.dart';
import 'constants/colors.dart';
import 'widgets/categories_section.dart';
import 'widgets/products_section.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: const Text(
          "HOME",
          style: TextStyle(
              fontSize: 28.0, fontWeight: FontWeight.bold, color: tdBlack),
        ),
        //backgroundColor: tdBGColor,
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: ProductSearch());
            },
            icon: const Icon(
              Icons.search,
              color: tdBlack,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const CartPage(),
              ));
            },
            icon: const Icon(
              Icons.shopping_cart,
              color: tdBlack,
            ),
          ),
        ],
      ),
      body: const Column(
        children: [
          CategoriesSection(),
          Expanded(child: ProductsSection()),
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
