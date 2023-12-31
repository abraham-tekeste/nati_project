import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String name, id;
  final List<String> images;
  final double price;

  Product({
    required this.name,
    required this.id,
    required this.price,
    required this.images,
    //required String image,
  });

  factory Product.fromFireStore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data() ?? {};

    return Product(
      id: snapshot.id,
      name: data['name'] ?? 'Unknown product',
      price: data['price'] ?? 0,
      images:
          data['images'] is Iterable ? List<String>.from(data['images']) : [],
    );
  }

  factory Product.fromQueryFireStore(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot) {
    final json = snapshot.data();

    return Product(
      id: snapshot.id,
      name: json['name'] ?? 'Unknown product',
      price: json['price'] ?? 0,
      images:
          json['images'] is Iterable ? List<String>.from(json['images']) : [],
    );
  }

  Map<String, dynamic> toFireStore() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'image': images,
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

  double get priceValue => price / 100;
  @override
  int get hashCode => Object.hash(id, name);

  @override
  bool operator ==(covariant Product other) {
    return identical(this, other) || id == other.id;
  }
}
