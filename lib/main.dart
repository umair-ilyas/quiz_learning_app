import 'package:flutter/material.dart';
import 'app/di/injection.dart';
import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();
  runApp(const App());
}
