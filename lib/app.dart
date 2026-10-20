import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yoon_wi/core/router/app_router.dart';
import 'package:yoon_wi/core/theme/app_theme.dart';

class YoonWiApp extends StatefulWidget {
  const YoonWiApp({super.key});

  @override
  State<YoonWiApp> createState() => _YoonWiAppState();
}

class _YoonWiAppState extends State<YoonWiApp> {
  late final GoRouter _router = createAppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Yoon Wi',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: _router,
    );
  }
}
