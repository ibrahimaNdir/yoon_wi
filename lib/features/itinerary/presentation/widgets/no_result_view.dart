import 'package:flutter/material.dart';

import 'package:yoon_wi/shared/widgets/empty_state.dart';
import 'package:yoon_wi/shared/widgets/primary_button.dart';
import 'package:yoon_wi/shared/widgets/secondary_button.dart';

class NoResultView extends StatelessWidget {
  const NoResultView({super.key, required this.onEdit, this.onPreferences});

  final VoidCallback onEdit;
  final VoidCallback? onPreferences;

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.highlight_off,
      title: 'Aucun itinéraire trouvé',
      message:
          'Ce lieu n’est pas encore desservi par les réseaux de la première version : TER, BRT, Tata et Dem Dikk. Vous pouvez aussi élargir les réseaux ou la marche maximale.',
      actions: [
        PrimaryButton(label: 'Modifier la recherche', onPressed: onEdit),
        if (onPreferences != null)
          SecondaryButton(
            label: 'Changer les préférences',
            onPressed: onPreferences,
          ),
        const SizedBox.shrink(),
      ],
    );
  }
}
