import 'package:flutter/material.dart';
import 'package:yoon_wi/shared/widgets/coming_soon_page.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) =>
      const ComingSoonPage(title: 'Itinéraire', step: 'F7');
}
