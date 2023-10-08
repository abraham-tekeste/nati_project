import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/category_model.dart';

final selectedCategoryProvider =
    StateProvider<Category>((ref) => Category(name: 'All', id: 'All'));

final categoriesProvider = StreamProvider<List<Category>>((ref) {
  return FirebaseFirestore.instance
      .collection("categories")
      .snapshots()
      .map((s) => s.docs.map((d) => Category.fromFireStore(d)).toList());
});
