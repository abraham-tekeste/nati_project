import 'package:flutter/material.dart';

import '../categories_mngmt/category.dart';
import '../product_mngt/products_mngt_page.dart';
import '../product_mngt/screens/add_product_page.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CategoryManagement(),
                    ));
              },
              leading: const Icon(Icons.settings_applications),
              title: const Text('Categories mngt'),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ProdctsMngtPage(),
                ));
              },
              leading: const Icon(Icons.add),
              title: const Text('Products mngt'),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const AddProductPage(),
                ));
              },
              leading: const Icon(Icons.add),
              title: const Text('Add product'),
            )
          ],
        ),
      ),
    );
  }
}
