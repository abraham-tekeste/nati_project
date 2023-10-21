import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:nati_project/auth/controllers/user_provider.dart';
import 'package:nati_project/cart/model/cart_product.dart';
import 'dart:developer';

import '../home/model/product.dart';
import 'controllers/cart_provider.dart';

// this is comment for test github
class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final cartProducts = ref.watch(cartProvider);
    final totalPrice = ref.watch(priceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cartProducts.length,
              itemBuilder: (context, i) {
                return CartProductTile(cartProducts.elementAt(i));
              },
            ),
          ),
          Column(
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
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextInOrderDetails(
                              labelName: "Total quantity",
                              labelValue: cartProducts
                                  .fold(
                                      0,
                                      (previousValue, element) =>
                                          previousValue + element.quantity)
                                  .toString()),
                          TextInOrderDetails(
                              labelName: "Total items",
                              labelValue: cartProducts.length.toString()),
                          const TextInOrderDetails(
                              labelName: "Shipping Charges", labelValue: "0.0"),
                          const TextInOrderDetails(
                              labelName: "Total Tax", labelValue: "15%"),
                          TextInOrderDetails(
                              labelName: "Grand Total",
                              labelValue: totalPrice.toString()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const CheckOutButton(),
            ],
          ),
        ],
      ),
    );
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

                    ref.read(cartProvider.notifier).update((_) => {});

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

class TextInOrderDetails extends StatelessWidget {
  const TextInOrderDetails({
    required this.labelName,
    required this.labelValue,
    super.key,
  });

  final String labelName;
  final String labelValue;

  @override
  Widget build(BuildContext context) {
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
                    cartProduct.quantity++;
                    ref.read(cartProvider.notifier).state = {
                      ...ref.read(cartProvider.notifier).state
                    };
                  },
                  icon: const Icon(Icons.add)),
              IconButton(
                onPressed: () async {
                  try {
                    cartProduct.quantity--;
                    if (cartProduct.quantity < 1) {
                      ref.read(cartProvider.notifier).state = {
                        ...ref.read(cartProvider.notifier).state
                          ..removeWhere(
                            (element) => product.id == element.product.id,
                          )
                      };
                    } else {
                      ref.read(cartProvider.notifier).state = {
                        ...ref.read(cartProvider.notifier).state
                      };
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
