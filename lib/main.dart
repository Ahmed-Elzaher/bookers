import 'package:flutter/material.dart';
import 'package:bookers/app.dart';
import 'package:bookers/core/services/services_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupServiceLocator();

  runApp(const BookerApp());
}
