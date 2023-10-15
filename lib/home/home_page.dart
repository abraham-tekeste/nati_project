import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:nati_project/home/controllers/products_provider.dart';

import '../cart/cart_page.dart';
import '../categories_mngmt/models/category_model.dart';
import '../search/product_search_delegate.dart';
import 'constants/colors.dart';
import 'widgets/categories_section.dart';
import 'widgets/products_section.dart';

final categoryDisplayProvider =
    StateProvider<Category>((ref) => Category(name: "All"));

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
