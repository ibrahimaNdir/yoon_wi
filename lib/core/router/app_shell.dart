import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yoon_wi/shared/widgets/app_bottom_nav.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: AppBottomNav(
        currentIndex: navigationShell.currentIndex,
        onSelected:
            (index) => navigationShell.goBranch(
              index,
              // Toucher l'onglet déjà actif ramène à sa page de départ
              initialLocation: index == navigationShell.currentIndex,
            ),
      ),
    );
  }
}
