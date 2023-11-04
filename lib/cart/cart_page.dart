import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:nati_project/auth/controllers/user_provider.dart';
import 'package:nati_project/cart/model/cart_product.dart';

import 'controllers/cart_provider.dart';
import '../orders/orders_page.dart';

// this is comment for test github
class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    // final cartProducts = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FirestoreListView<CartProduct>(
              query: FirebaseFirestore.instance
                  .collection("carts")
                  .doc(FirebaseAuth.instance.currentUser!.uid)
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
                    ref.read(cartProvider.notifier).addToSet(doc.data());
                  },
                );
                return CartProductTile(doc.data());
              },
            ),
          ),
          Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              return Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.blue.shade50,
                    ),
                    constraints: const BoxConstraints(minHeight: 250),
                    margin: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Order Details",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          child: const Column(
                            // mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TotalQuantity(),
                              TotalItems(),
                              TextInOrderDetails(
                                  labelName: "Shipping Charges",
                                  labelValue: "0.0"),
                              TextInOrderDetails(
                                  labelName: "Total Tax", labelValue: "15%"),
                              GrandTotal(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const CheckOutButton(),
                  const CheckOutOrdersButton(),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class CheckOutOrdersButton extends ConsumerWidget {
  const CheckOutOrdersButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return const OrdersPage();
            },
          ));
        },
        style: ElevatedButton.styleFrom(minimumSize: const Size(300, 48)),
        child: const Text(
          "Go To Orders",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

class TotalQuantity extends ConsumerWidget {
  const TotalQuantity({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    final quantity = ref
        .watch(cartProvider)
        .fold(0, (previousValue, element) => previousValue + element.quantity)
        .toString();
    return TextInOrderDetails(
      labelName: "Total quantity",
      labelValue: quantity,
    );
  }
}

class TotalItems extends ConsumerWidget {
  const TotalItems({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    final cartProductsLength = ref.watch(cartProvider).length;
    return TextInOrderDetails(
        labelName: "Total items", labelValue: cartProductsLength.toString());
  }
}

class GrandTotal extends ConsumerWidget {
  const GrandTotal({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    final totalPrice = ref.watch(priceProvider);
    return TextInOrderDetails(
        labelName: "Grand Total", labelValue: totalPrice.toString());
  }
}

class CheckOutButton extends ConsumerWidget {
  const CheckOutButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    final cartProducts = ref.watch(cartProvider);

    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: ElevatedButton(
        onPressed: cartProducts.isEmpty
            ? null
            : () async {
                final totalPrice = cartProducts.fold<double>(
                    0, (previousValue, e) => previousValue + e.product.price);

                final userId = ref.read(userProvider).asData!.value!.uid;
                final checkOutRef = await FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .collection('checkout_sessions')
                    .add({
                  'client': 'mobile',
                  'mode': 'payment',
                  'amount': totalPrice,
                  'currency': 'usd',
                });

                late final StreamSubscription<
                        DocumentSnapshot<Map<String, dynamic>>>
                    checkOutSubscription;

                checkOutSubscription =
                    checkOutRef.snapshots().listen((checkOutSnap) async {
                  final data = checkOutSnap.data();

                  final clietSecret = data?['paymentIntentClientSecret'];
                  final ephemeralKeySecret = data?['ephemeralKeySecret'];

                  if (clietSecret != null) {
                    await Stripe.instance.initPaymentSheet(
                      paymentSheetParameters: SetupPaymentSheetParameters(
                        paymentIntentClientSecret: clietSecret,
                        customerEphemeralKeySecret: ephemeralKeySecret,
                        merchantDisplayName: 'Enda Areki',
                      ),
                    );

                    await Stripe.instance.presentPaymentSheet(
                        options: const PaymentSheetPresentOptions());
                    // await Stripe.instance.confirmPaymentSheetPayment();

                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(userId)
                        .collection('purchases')
                        .add({
                      'isDelivered': false,
                      'productsId': cartProducts.map((e) => e.product.id),
                    });

                    ref.read(cartProvider.notifier).makeOrder();

                    checkOutSubscription.cancel();
                  }
                });
              },
        style: ElevatedButton.styleFrom(minimumSize: const Size(300, 48)),
        child: const Text(
          'Proceed to payment',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

class TextInOrderDetails extends ConsumerWidget {
  const TextInOrderDetails({
    required this.labelName,
    required this.labelValue,
    super.key,
  });

  final String labelName;
  final String labelValue;

  @override
  Widget build(BuildContext context, ref) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            labelName,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            labelValue,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}

class CartProductTile extends ConsumerWidget {
  const CartProductTile(this.cartProduct, {super.key});

  final CartProduct cartProduct;

  @override
  Widget build(BuildContext context, ref) {
    final product = cartProduct.product;

    //final cartProviderNotifier = ref.read(cartProvider.notifier);
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(product.name),
              Text(cartProduct.quantity.toString()),
              Text(product.priceValue.toString()),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              IconButton(
                  onPressed: () {
                    try {
                      FirebaseFirestore.instance
                          .collection(FireStoreKeys.cartCollection)
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection('cartProducts')
                          .doc(cartProduct.product.id)
                          .update(
                        {'quantity': FieldValue.increment(1)},
                      );
                    } on Exception catch (e) {
                      print(e);
                    }
                  },
                  icon: const Icon(Icons.add)),
              IconButton(
                onPressed: () async {
                  try {
                    print("cartproduct quantity " + cartProduct.toString());
                    if (cartProduct.quantity > 1) {
                      FirebaseFirestore.instance
                          .collection(FireStoreKeys.cartCollection)
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection('cartProducts')
                          .doc(cartProduct.product.id)
                          .update(
                        {'quantity': FieldValue.increment(-1)},
                      );
                    } else {
                      ref
                          .read(cartProvider.notifier)
                          .removeCartProducts(product.id);
                      await FirebaseFirestore.instance
                          .collection(FireStoreKeys.cartCollection)
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection('cartProducts')
                          .doc(cartProduct.product.id)
                          .delete();
                    }
                  } on Exception catch (e) {
                    log(e.toString());
                  }
                },
                icon: const Icon(Icons.remove),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FireStoreKeys {
  static final String cartCollection = "carts";
}
