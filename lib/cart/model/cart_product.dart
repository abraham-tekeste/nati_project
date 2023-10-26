import 'package:nati_project/home/model/product.dart';

class CartProduct {
  final Product product;
  int quantity;

  CartProduct({required this.product, required this.quantity});

  @override
  int get hashCode => Object.hash(product.id, product.name);

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
}
