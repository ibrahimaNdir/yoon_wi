import 'package:flutter/material.dart';
import 'package:yoon_wi/core/constants/transport_mode.dart';
import 'package:yoon_wi/core/theme/app_text_styles.dart';
import 'package:yoon_wi/core/theme/app_theme.dart';
import 'package:yoon_wi/shared/widgets/breadcrumb.dart';
import 'package:yoon_wi/shared/widgets/empty_state.dart';
import 'package:yoon_wi/shared/widgets/loading_skeleton.dart';
import 'package:yoon_wi/shared/widgets/price_label.dart';
import 'package:yoon_wi/shared/widgets/primary_button.dart';
import 'package:yoon_wi/shared/widgets/secondary_button.dart';
import 'package:yoon_wi/shared/widgets/transport_chip.dart';

class YoonWiApp extends StatelessWidget {
  const YoonWiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yoon Wi',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const _PreviewPage(),
    );
  }
}

// TEMPORAIRE : remplacée par le routeur en F2.
class _PreviewPage extends StatelessWidget {
  const _PreviewPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yoon Wi')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text('Où allez-vous aujourd’hui ?', style: AppTextStyles.h1),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [for (final m in TransportMode.values) TransportChip(m)],
          ),
          const SizedBox(height: 16),
          const PriceLabel(2600, large: true),
          const SizedBox(height: 16),
          Breadcrumb(
            items: [
              BreadcrumbItem('Réseaux', onTap: () {}),
              BreadcrumbItem('Dakar Dem Dikk', onTap: () {}),
              const BreadcrumbItem('Ligne 10'),
            ],
          ),
          const SizedBox(height: 16),
          PrimaryButton(label: 'Voir les itinéraires', onPressed: () {}),
          const SizedBox(height: 12),
          SecondaryButton(label: 'Annuler', onPressed: () {}),
          const SizedBox(height: 16),
          const LoadingSkeleton(),
          const SizedBox(height: 16),
          const SizedBox(
            height: 260,
            child: EmptyState(
              title: 'Aucune ligne disponible',
              message:
                  'Les lignes de ce type de transport ne sont pas encore renseignées.',
            ),
          ),
        ],
      ),
    );
  }
}
