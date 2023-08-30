import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'controllers/counter_notifier.dart';

class SecondPage extends ConsumerWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(counterProvider('-15'));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Second Page"),
      ),
      body: Column(
        children: [
          Center(
              child: Text(
            counter.toString(),
            style: Theme.of(context).textTheme.headlineLarge,
          )),
          ElevatedButton(
            onPressed: () {
              ref.read(counterProvider('-15').notifier).increment(3);
            },
            child: const Text("Increment"),
          ),
        ],
      ),
    );
  }
}
