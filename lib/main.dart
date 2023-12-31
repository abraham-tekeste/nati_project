//import 'package:algolia/algolia.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:nati_project/app.dart';
import 'package:nati_project/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Stripe.publishableKey =
      'pk_test_51Nyte0IN5v0ZfdQFgarGpWPq35cNVtoJVUCn7lMKFIxOJZdfTTdGVvwqFjxa8G9YPkn4SJ9C6kGN66o64X3UZGwJ00ZAoXx1OX';
  // Stripe.merchantIdentifier;

  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}
