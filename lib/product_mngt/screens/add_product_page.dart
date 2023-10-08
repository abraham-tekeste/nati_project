import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddProductPage extends StatelessWidget {
  const AddProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add product'),
        elevation: 0.0,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            ProductNameField(),
            SizedBox(height: 24),
            PriceField(),
            SizedBox(height: 48),
            SubmitButton(),
          ],
        ),
      ),
    );
  }
}

final textFieldControllerProvider =
    StateProvider.autoDispose<TextEditingController>((ref) {
  return TextEditingController();
});
final productPriceControllerProvider =
    StateProvider.autoDispose<TextEditingController>((ref) {
  return TextEditingController();
});

class PriceField extends ConsumerWidget {
  const PriceField({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final productPriceController = ref.watch(productPriceControllerProvider);

    return TextFormField(
      controller: productPriceController,
      decoration: const InputDecoration(
        labelText: 'Price',
      ),
    );
  }
}

class ProductNameField extends HookConsumerWidget {
  const ProductNameField({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final productNameController = ref.watch(textFieldControllerProvider);

    return TextFormField(
      controller: productNameController,
      decoration: const InputDecoration(
        labelText: 'Product name',
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
    final productPriceController = ref.watch(productPriceControllerProvider);

    return OutlinedButton(
      style: OutlinedButton.styleFrom(minimumSize: const Size(200, 50)),
      onPressed: () {
        final name = productNameController.text;
        final price = double.parse(productPriceController.text);
        createProductToFirebase(name: name, price: price);
      },
      child: Text(
        "submit form".toUpperCase(),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Future createProductToFirebase(
      {required String name, required double price}) async {
    //print("i was called");
    //reference to
    // final product = Product(name: name, price: price, image: "assets/images/areki.jpeg");
    // final json = product.toFireStore();

    // FirebaseFirestore.instance.collection('products').add(json);
  }
}
