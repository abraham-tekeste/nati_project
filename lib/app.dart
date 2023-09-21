import 'package:algolia/algolia.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nati_project/splash_screen.dart';

//import 'home/home_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

final algoliaProvider = Provider<Algolia>((ref) {
  return const Algolia.init(
    applicationId: 'QBJM532ELH',
    apiKey: '77f76722164033a5f9747a66e4214db6',
  );
});
