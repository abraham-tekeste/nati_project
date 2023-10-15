import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String name, id;
  final List<String> images;
  final double price;

  Product({
    required this.name,
    this.id = '',
    required this.price,
    required this.images,
  });

  factory Product.fromFireStore(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot) {
    final json = snapshot.data();

    return Product(
      id: snapshot.id,
      name: json['name'] ?? 'Unknown product',
      price: 0,
      images:
          json['images'] is Iterable ? List<String>.from(json['images']) : [],
    );
  }

  Map<String, dynamic> toFireStore() {
    return {
      // 'name': name,
      // 'price': price,
      // 'image': image,
    };
  }

  Product copyWith({
    double? price,
  }) {
    return Product(
      id: id,
      name: name,
      price: price ?? this.price,
      images: images,
    );
  }

  String get thumbnail => images.isEmpty ? '' : images.first;
}
