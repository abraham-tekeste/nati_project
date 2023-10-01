import 'package:flutter/material.dart';

import '../categories_mngmt/category.dart';
import '../product_mngt/products_mngt_page.dart';
import '../product_mngt/screens/add_product_page.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: const Text(
          "MENU",
          style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white, //Color(0xFFFEF9EB),
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), topLeft: Radius.circular(30)),
        ),
        child: SingleChildScrollView(
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
                trailing: const Icon(Icons.navigate_next),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ProductsMngtPage(),
                  ));
                },
                leading: const Icon(Icons.production_quantity_limits),
                title: const Text('Products mngt'),
                trailing: const Icon(Icons.navigate_next),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const AddProductPage(),
                  ));
                },
                leading: const Icon(Icons.add),
                title: const Text('Add product'),
                trailing: const Icon(Icons.navigate_next),
              )
            ],
          ),
        ),
      ),
    );
  }
}
