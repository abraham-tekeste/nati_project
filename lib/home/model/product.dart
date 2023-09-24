import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String name, id, image;
  final double price;

  Product({
    required this.name,
    this.id = '',
    required this.price,
    required this.image,
  });

  factory Product.fromFireStore(QueryDocumentSnapshot<Map<String, dynamic>> snapshot) {
    final json = snapshot.data();

    return Product(
      id: snapshot.id,
      name: json['name'] ?? 'Unknown product',
      price: double.tryParse('${json['price']}') ?? 0,
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toFireStore() {
    return {
      'name': name,
      'price': price,
      'image': image,
    };
  }
}
