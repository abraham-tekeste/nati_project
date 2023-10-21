import 'package:nati_project/home/model/product.dart';

class CartProduct {
  final Product product;
  int quantity;

  CartProduct({required this.product, required this.quantity});

  @override
  int get hashCode => Object.hash(product.id, product.name);

  @override
  bool operator ==(covariant CartProduct other) {
    return identical(this, other) || product.id == other.product.id;
  }
}
