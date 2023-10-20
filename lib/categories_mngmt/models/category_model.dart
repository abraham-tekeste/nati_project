import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  final String name, id;

  Category({
    required this.name,
    this.id = '',
  });

  factory Category.fromFireStore(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot) {
    final json = snapshot.data();

    return Category(
      id: snapshot.id,
      name: json['name'] ?? 'Unknown Category',
    );
  }

  Map<String, dynamic> toFireStore() {
    return {
      'name': name,
    };
  }
}
