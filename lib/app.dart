import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nati_project/auth/controllers/user_provider.dart';

import 'home/main_nav.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(),
      // themeMode: ThemeMode.system,
      // theme: TAppTheme.lightTheme,
      // darkTheme: TAppTheme.darkTheme,
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
      //   useMaterial3: true,
      // ),
      home: const AuthGate(),
    );
  }
}

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final isAuthenticated = ref.watch(isAuthenticatedProvider);

    return Visibility(
      visible: isAuthenticated,
      replacement: const LoginPage(),
      child: const MainNav(),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SignInScreen(
      providers: [
        EmailAuthProvider(),
      ],
    );
  }
}
