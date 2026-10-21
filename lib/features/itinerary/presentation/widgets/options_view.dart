import 'package:flutter/material.dart';
import 'package:yoon_wi/core/theme/app_text_styles.dart';
import 'package:yoon_wi/core/utils/plural.dart';
import 'package:yoon_wi/features/itinerary/domain/entities/itinerary.dart';
import 'package:yoon_wi/features/itinerary/presentation/widgets/option_card.dart';

class OptionsView extends StatelessWidget {
  const OptionsView({
    super.key,
    required this.itineraries,
    required this.onSelect,
  });

  final List<Itinerary> itineraries;
  final ValueChanged<Itinerary> onSelect;

  @override
  Widget build(BuildContext context) {
    final n = itineraries.length;
    final found = '${plural(n, 'itinéraire')} ${n > 1 ? 'trouvés' : 'trouvé'}';
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(found, style: AppTextStyles.bodyMuted),
        const SizedBox(height: 12),
        for (final itinerary in itineraries) ...[
          OptionCard(itinerary: itinerary, onTap: () => onSelect(itinerary)),
          const SizedBox(height: 16),
        ],
      ],
    );
  }
}
