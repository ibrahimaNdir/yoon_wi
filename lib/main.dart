import 'package:flutter/material.dart';
import 'package:yoon_wi/app.dart';
import 'package:yoon_wi/core/di/injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(const YoonWiApp());
}
