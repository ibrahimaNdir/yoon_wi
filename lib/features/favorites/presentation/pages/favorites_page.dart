import 'package:flutter/material.dart';
import 'package:yoon_wi/shared/widgets/coming_soon_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) =>
      const ComingSoonPage(title: 'Favoris', step: 'F11');
}
