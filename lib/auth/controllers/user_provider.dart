import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  final user = ref.watch(userProvider).asData?.value;
  return user != null;
});
