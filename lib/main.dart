import 'package:flutter/material.dart';
import 'package:bookers/app.dart';
import 'package:bookers/core/services/services_locator.dart';

//! =========================================================
//! Main Entry Point
//! =========================================================

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة حقن التبعيات (GetIt)
  await setupServiceLocator();

  runApp(const BookerApp());
}
