import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nati_project/home/controllers/counter_provider.dart';
import 'package:nati_project/home/second_page.dart';

import 'widgets/increment_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              final result = await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const SecondPage(),
              ));
            },
            icon: const Icon(Icons.account_box),
          )
        ],
      ),
      body: const Center(
        child: Column(
          children: [
            CounterText(),
            SizedBox(
              height: 100,
            ),
            // CounterFutureText(),
          ],
        ),
      ),
      persistentFooterAlignment: AlignmentDirectional.center,
      persistentFooterButtons: const [
        DecrementButton(),
        SizedBox(
          width: 100,
        ),
        IncrementButton(),
      ],
    );
  }
}

class CounterFutureText extends ConsumerWidget {
  const CounterFutureText({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    final counterAsync = ref.watch(counterStreamProvider);

    return counterAsync.when(
      data: (counter) {
        return Text(
          '$counter',
          style: Theme.of(context).textTheme.headlineLarge,
        );
      },
      error: (e, s) {
        return Text(
          '$e',
          style: Theme.of(context).textTheme.headlineLarge,
        );
      },
      loading: () {
        return Text(
          'Loading..',
          style: Theme.of(context).textTheme.headlineLarge,
        );
      },
    );
  }
}
