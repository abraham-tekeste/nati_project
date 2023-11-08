import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nati_project/cart/model/cart_product.dart';
import 'package:nati_project/orders/orders_provider.dart';

import 'order_details_page.dart';

class OrdersPage extends ConsumerWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final orderProviderAsync = ref.watch(ordersProvider);
    // final qr = [];
    // FirebaseFirestore.instance
    //     .collection(
    //         "orders") // Replace "your_collection" with your actual collection name
    //     .get()
    //     .then((QuerySnapshot querySnapshot) {
    //   for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
    //     String docId = documentSnapshot.id;
    //     qr.add(docId);
    //     // Map<String, dynamic> data =
    //     //     documentSnapshot.data() as Map<String, dynamic>;

    //     // Use docId and data as needed for each document
    //   }
    // }).catchError((error) {
    //   print("Error: $error");
    // });

    // for (var e in qr) {
    //   print(e);
    // }

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text("ORDERS"),
      ),
      body: Column(
        children: [
          const OrderTextWidget(),
          // Expanded(
          //   child: Column(
          //     children: [
          //       orderProviderAsync.when(data: (orders) {
          //         return Column(
          //           children: orders
          //               .map((cartProduct) => OrdersTile(cartProduct))
          //               .toList(),
          //         );
          //       }, error: (e, s) {
          //         return Text("$e");
          //       }, loading: () {
          //         return const CircularProgressIndicator();
          //       })
          //     ],
          //   ),
          // ),

          Expanded(
            child: FirestoreListView<CartProduct>(
              query: FirebaseFirestore.instance
                  .collection("orders")
                  .doc("525LoPmdHjmqc5obKdFE")
                  // .doc('W7UghHOBv4ZubklGmaj60oPW4tB3')
                  .collection('cartProducts')
                  .withConverter(
                    fromFirestore: CartProduct.fromFireStore,
                    toFirestore: (value, options) {
                      return value.toFireStore();
                    },
                  ),
              errorBuilder: (context, error, stackTrace) => Text("$error"),
              loadingBuilder: (context) => const CircularProgressIndicator(),
              itemBuilder: (context, doc) {
                Future(
                  () {
                    ref.read(ordersProvider.notifier).addToSet(doc.data());
                  },
                );
                return OrdersTile(doc.data());
              },
            ),
          ),
        ],
      ),
    );
  }
}

class OrderTextWidget extends StatelessWidget {
  const OrderTextWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 20, left: 10, bottom: 10),
          child: Text(
            "Orders List",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

class OrdersTile extends ConsumerWidget {
  const OrdersTile(this.cartProduct, {super.key});

  final CartProduct cartProduct;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const CircleAvatar(
          backgroundImage: AssetImage("assets/images/areki.jpeg")),
      title: Text(cartProduct.product.name),
      subtitle: const Text("Order # 304973765"),
      trailing: const Icon(Icons.navigate_next),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderDetailsPage(cartProduct),
            ));
      },
    );
  }
}
