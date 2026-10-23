import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yoon_wi/core/router/route_names.dart';
import 'package:yoon_wi/core/theme/app_colors.dart';
import 'package:yoon_wi/core/theme/app_text_styles.dart';
import 'package:yoon_wi/features/itinerary/domain/entities/step.dart';
import 'package:yoon_wi/shared/widgets/primary_button.dart';
import 'package:yoon_wi/shared/widgets/secondary_button.dart';
import 'package:yoon_wi/shared/widgets/transport_chip.dart';

/// Écran de démonstration : aucune donnée de perturbation réelle n'existe
/// encore. Il s'ouvre par un appui long sur le titre du guidage, dans les
/// versions de développement seulement.
class DisruptionAlertPage extends StatelessWidget {
  const DisruptionAlertPage({super.key, this.step});

  final ItineraryStep? step;

  @override
  Widget build(BuildContext context) {
    final mode = step?.mode;
    final line =
        mode == null ? 'Votre ligne' : '${mode.label} ${step!.lineName}';
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Fermer',
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.ink,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Yoon Wi · maintenant\nPerturbation sur $line, votre trajet est touché.',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Semantics(
                    header: true,
                    child: const Text(
                      'Perturbation sur votre trajet',
                      style: AppTextStyles.h1,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.line),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (mode != null) TransportChip(mode),
                        const SizedBox(height: 10),
                        Text(
                          'Retard estimé : 10 min (exemple)',
                          style: AppTextStyles.h2.copyWith(fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text('Sur $line', style: AppTextStyles.bodyMuted),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Vous pouvez relancer le calcul de votre trajet.',
                    style: AppTextStyles.bodyMuted,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Écran de démonstration : aucune donnée en direct n’est encore branchée.',
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  PrimaryButton(
                    label: 'Recalculer mon trajet',
                    onPressed: () => context.go(RouteNames.results),
                  ),
                  const SizedBox(height: 12),
                  SecondaryButton(
                    label: 'Garder l’itinéraire',
                    onPressed: () => context.pop(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
