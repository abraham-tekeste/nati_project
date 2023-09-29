import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../product_mngt/screens/add_product_page.dart';
import 'models/category_model.dart';

class AddCategoryPage extends StatelessWidget {
  const AddCategoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Category"),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        decoration: const BoxDecoration(
            // color: Colors.purple,
            ),
        child: const Column(
          children: [
            CategoryNameField(),
            SizedBox(
              height: 100,
            ),
            SubmitButton(),
          ],
        ),
      ),
    );
  }
}

class CategoryNameField extends HookConsumerWidget {
  const CategoryNameField({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final productNameController = ref.watch(textFieldControllerProvider);

    return TextFormField(
      controller: productNameController,
      decoration: const InputDecoration(
        labelText: 'Category name',
      ),
    );
  }
}

class SubmitButton extends ConsumerWidget {
  const SubmitButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    final productNameController = ref.watch(textFieldControllerProvider);

    return OutlinedButton(
      style: OutlinedButton.styleFrom(minimumSize: const Size(200, 50)),
      onPressed: () {
        final name = productNameController.text;
        createCategoryToFirebase(
          name: name,
        );
      },
      child: Text(
        "submit form".toUpperCase(),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Future createCategoryToFirebase({
    required String name,
  }) async {
    log("@@@ $name");
    try {
      final category = Category(
        name: name,
      );
      final json = category.toFireStore();
      log("@@@ $json");

      await FirebaseFirestore.instance.collection('categories').add(json);
    } catch (e) {
      log('@@@ error occured $e');
    }
    //print("i was called");
    //reference to
  }
}
