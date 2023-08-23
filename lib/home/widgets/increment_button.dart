import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/counter_provider.dart';

class IncrementButton extends ConsumerWidget {
  const IncrementButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    return IconButton(
      onPressed: () {
        ref.read(counterProvider(-5).notifier).state++;
      },
      icon: const Icon(Icons.add),
    );
  }
}

class DecrementButton extends ConsumerWidget {
  const DecrementButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    return IconButton(
      onPressed: () {
        ref.read(counterProvider(-5).notifier).state--;
      },
      icon: const Icon(Icons.remove),
    );
  }
}

class CounterText extends ConsumerWidget {
  const CounterText({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    final counter = ref.watch(counterProvider(-5));

    return Text(
      '$counter',
      style: Theme.of(context).textTheme.displayLarge,
    );
  }
}
