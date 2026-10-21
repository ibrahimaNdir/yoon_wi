import 'package:flutter/material.dart';
import 'package:yoon_wi/core/theme/app_text_styles.dart';
import 'package:yoon_wi/shared/widgets/loading_skeleton.dart';
import 'package:yoon_wi/shared/widgets/secondary_button.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key, required this.onCancel});

  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 16),
                Semantics(
                  liveRegion: true,
                  label: 'Recherche du meilleur trajet en cours',
                  child: const ExcludeSemantics(
                    child: Column(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text(
                          'Recherche du meilleur trajet',
                          style: AppTextStyles.h2,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Nous comparons le TER, le BRT, les Tata et Dem Dikk.',
                          style: AppTextStyles.bodyMuted,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const LoadingSkeleton(),
                const SizedBox(height: 12),
                const LoadingSkeleton(),
                const Spacer(),
                const SizedBox(height: 24),
                SecondaryButton(label: 'Annuler', onPressed: onCancel),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
