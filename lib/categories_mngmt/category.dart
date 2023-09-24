//import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:nati_project/categories_mngmt/add_category_page.dart';

class CategoryManagement extends StatelessWidget {
  const CategoryManagement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Category Management"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const AddCategoryPage(),));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
