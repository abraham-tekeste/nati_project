import 'package:flutter_riverpod/flutter_riverpod.dart';

// final counterProvider = StateProvider.family<int, int>((ref, arg) {
//   return 0;
// });

final counterFutureProvider = FutureProvider<int>((ref) async {
  return calculate();
});

Future<int> calculate() async {
  await Future.delayed(const Duration(seconds: 2));

  return 11;
}

final counterStreamProvider = StreamProvider<int>((ref) async* {
  for (var i = 0; i < 10; i++) {
    await Future.delayed(const Duration(seconds: 1));
    if (i == 5) {
      throw Exception('Error');
    }
    yield i;
  }
});
