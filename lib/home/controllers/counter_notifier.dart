import 'package:flutter_riverpod/flutter_riverpod.dart';

final counterProvider =
    NotifierProvider.family<CounterNotifier, int, String>(CounterNotifier.new);

class CounterNotifier extends FamilyNotifier<int, String> {
  @override
  build(arg) {
    return int.tryParse(arg) ?? 0;
  }

  void increment([int value = 1]) {
    state = state + value;
  }

  void decrement([int value = 1]) {
    state = state - value;
  }
}
