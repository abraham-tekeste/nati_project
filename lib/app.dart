import 'package:flutter/material.dart';

import 'home/main_nav.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
        //accentColor: Color(0xFFFEF9EB),
        //hintColor: const Color(0xFFFEF9EB),
      ),
      home: const MainNav(),
    );
  }
}
