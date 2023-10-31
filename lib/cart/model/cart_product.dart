import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nati_project/home/model/product.dart';

class CartProduct {
  final Product product;
  int quantity;

  CartProduct({required this.product, required this.quantity});

  factory CartProduct.fromFireStore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final json = snapshot.data();

    return CartProduct(
        product: Product.fromFireStore(snapshot),
        quantity: json?['quantity'] ?? 0);
  }

  Map<String, dynamic> toFireStore() {
    return product.toFireStore()..addAll({'quantity': quantity});
  }

  @override
  int get hashCode => Object.hash(product.id, product.name, quantity);

  // CartProduct copyWith({int? quantity}) {
  //   return CartProduct(
  //     product: product,
  //     quantity: quantity ??
  //         this.quantity, // Use the new quantity if provided, or keep the old one
  //   );
  // }

  @override
  bool operator ==(covariant CartProduct other) {
    return identical(this, other) || product.id == other.product.id;
  }

  @override
  String toString() {
    return "cartProduct (${product.name},$quantity)";
  }
}
