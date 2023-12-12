import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nati_project/cart/model/cart_product.dart';

final ordersProvider =
    NotifierProvider<OrdersNotifier, Set<CartProduct>>(OrdersNotifier.new);

class OrdersNotifier extends Notifier<Set<CartProduct>> {
  @override
  build() {
    return {};
  }

  void addToSet(CartProduct c) {
    final index = state
        .toList()
        .indexWhere((element) => element.product.id == c.product.id);
    if (index == -1) {
      state = {...state, c};
    } else {
      state.elementAt(index).quantity = c.quantity;
      state = {...state};
    }
  }
}
// collection->documents->collection->documents
// final ordersProvider = StreamProvider<Set<CartProduct>>((ref) {
//   return FirebaseFirestore.instance
//       .collection("orders")
//       .doc("525LoPmdHjmqc5obKdFE")
//       .collection("CartProducts")
//       .snapshots()
//       .map((s) => s.docs
//           .map((d) => CartProduct.fromFireStore(d, SnapshotOptions()))
//           .toSet());
// });
