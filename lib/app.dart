import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nati_project/instruction.dart';
import 'package:riverpod/riverpod.dart';

// final counterProvider = Provider<int>((ref) {
//   return 5;
// });

final counterProvider = StateProvider<int>((ref) {
  return 0;
});

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

// ConsumerWidget

// Consumer

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Column(
          children: [
            CounterText(),
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

class IncrementButton extends StatelessWidget {
  const IncrementButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return IconButton(
          onPressed: () {
            ref.read(counterProvider.notifier).state++;
          },
          icon: const Icon(Icons.add),
        );
      },
    );
  }
}

class DecrementButton extends StatelessWidget {
  const DecrementButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return IconButton(
          onPressed: () {
            ref.read(counterProvider.notifier).state--;
          },
          icon: const Icon(Icons.remove),
        );
      },
    );
  }
}

class CounterText extends StatelessWidget {
  const CounterText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final counter = ref.watch(counterProvider);

        return Text('$counter');
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      _counter--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Instruction(),
            Counter(counter: _counter),
            ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AnotherPage(_counter),
                  ),
                );

                if (result is int) {
                  setState(() {
                    _counter = result;
                  });
                }
              },
              child: const Text('Go to next page'),
            ),
          ],
        ),
      ),
      persistentFooterAlignment: AlignmentDirectional.center,
      persistentFooterButtons: [
        IconButton(
          onPressed: _decrementCounter,
          icon: const Icon(Icons.remove),
        ),
        const SizedBox(
          width: 100,
        ),
        IconButton(
          onPressed: _incrementCounter,
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}

class Counter extends StatefulWidget {
  const Counter({
    super.key,
    required int counter,
  }) : _counter = counter;

  final int _counter;

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Text(
          '${widget._counter}',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}

class AnotherPage extends StatefulWidget {
  AnotherPage(this.counter, {super.key});

  int counter;

  @override
  State<AnotherPage> createState() => _AnotherPageState();
}

class _AnotherPageState extends State<AnotherPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, widget.counter);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Another'),
      ),
      body: Center(
        child: Column(
          children: [
            Text(widget.counter.toString()),
          ],
        ),
      ),
      persistentFooterButtons: [
        IconButton(
          onPressed: () {
            setState(() {
              widget.counter++;
            });
          },
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
