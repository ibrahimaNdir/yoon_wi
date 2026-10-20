import 'package:flutter/material.dart';
import 'package:yoon_wi/shared/widgets/empty_state.dart';

class ComingSoonPage extends StatelessWidget {
  const ComingSoonPage({super.key, required this.title, required this.step});

  final String title;
  final String step;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: EmptyState(
        title: 'Bientôt disponible',
        message: 'Cet écran sera construit à l’étape $step.',
        icon: Icons.construction_outlined,
      ),
    );
  }
}
