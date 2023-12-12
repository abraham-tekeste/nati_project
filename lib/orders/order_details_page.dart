import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nati_project/cart/model/cart_product.dart';

class OrderDetailsPage extends ConsumerWidget {
  const OrderDetailsPage(this.cartProduct, {super.key});
  final CartProduct cartProduct;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final qr = FirebaseFirestore.instance
    //     .collection("orders")
    //     .doc("525LoPmdHjmqc5obKdFE");
    // print(qr);
    // Future<void> getDocumentsInCollection() async {
    //   final querySnapshot = FirebaseFirestore.instance.collection("order").snapshots().first;
    //   for (QueryDocumentSnapshot document in querySnapshot.docs) {
    //     String docId = document.id;
    //     print("Document ID: $docId");
    //     print("reached here");
    //   }
    // }

    // getDocumentsInCollection();

    // FirebaseFirestore.instance.collection("order").snapshots().listen(
    //   (s) {
    //     s.docs.forEach((e) {
    //       log(e.id);
    //     });
    //   },
    // );e

    return Scaffold(
      // backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("Order Details"),
      ),
      body: Column(
        children: [
          const OrderDetailTextWidget(),
          const SizedBox(
            height: 5,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                children: [
                  Text(
                    "order #304973765",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "placed on 01-12-2022",
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          OrderWidget(cartProduct: cartProduct),
          const DeliveryDetails(),
        ],
      ),
    );
  }
}

class OrderWidget extends StatelessWidget {
  const OrderWidget({
    super.key,
    required this.cartProduct,
  });

  final CartProduct cartProduct;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      margin: const EdgeInsets.all(8),
      child: Column(
        children: [
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 150,
                height: 100,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/areki.jpeg"),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text("name:"),
                        Text(
                          cartProduct.product.name,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text("price:"),
                        Text(
                          cartProduct.product.priceValue.toString(),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
          const Divider(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class OrderDetailTextWidget extends StatelessWidget {
  const OrderDetailTextWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "Your order Item",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}

class DeliveryDetails extends StatelessWidget {
  const DeliveryDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 400,
      child: Column(
        children: [
          Text(
            "Delivery Options",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            "Door Delivery",
            style: TextStyle(
              fontSize: 12,
            ),
          ),
          Divider(),
          Text(
            "Shiiping Address",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            "Natnael Melake",
            style: TextStyle(
              fontSize: 12,
            ),
          ),
          Text(
            " Asimewe A complex",
            style: TextStyle(
              fontSize: 12,
            ),
          ),
          Text(
            "Kampala Region Buziga",
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
