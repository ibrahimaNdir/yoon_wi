import 'package:flutter/material.dart';
import 'package:yoon_wi/core/constants/transport_mode.dart';
import 'package:yoon_wi/core/theme/app_colors.dart';
import 'package:yoon_wi/core/theme/app_text_styles.dart';
import 'package:yoon_wi/core/utils/duration_formatter.dart';
import 'package:yoon_wi/core/utils/plural.dart';
import 'package:yoon_wi/core/utils/price_formatter.dart';
import 'package:yoon_wi/features/itinerary/domain/entities/itinerary.dart';
import 'package:yoon_wi/features/itinerary/presentation/widgets/transport_chips_row.dart';
import 'package:yoon_wi/shared/widgets/price_label.dart';

class OptionCard extends StatelessWidget {
  const OptionCard({super.key, required this.itinerary, required this.onTap});

  final Itinerary itinerary;
  final VoidCallback onTap;

  static Color colorOf(Itinerary i) {
    switch (i.label) {
      case ItineraryLabel.eco:
        return AppColors.primary;
      case ItineraryLabel.express:
        return TransportMode.ter.color;
      case ItineraryLabel.fewerTransfers:
        return TransportMode.ddd.color;
    }
  }

  static String badgeOf(Itinerary i) {
    switch (i.label) {
      case ItineraryLabel.eco:
        return 'Éco · le moins cher';
      case ItineraryLabel.express:
        return 'Express · le plus rapide';
      case ItineraryLabel.fewerTransfers:
        return i.transfers == 0
            ? 'Sans correspondance'
            : 'Moins de correspondances';
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = colorOf(itinerary);
    final badge = badgeOf(itinerary);
    final duration = DurationFormatter.range(
      itinerary.minMinutes,
      itinerary.maxMinutes,
    );
    final transfers =
        itinerary.transfers == 0
            ? 'Direct'
            : plural(itinerary.transfers, 'correspondance');

    return Semantics(
      button: true,
      label:
          '$badge, ${PriceFormatter.format(itinerary.fare)}, '
          '$duration, $transfers',
      excludeSemantics: true,
      onTap: onTap,
      child: Material(
        color: AppColors.surface,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: color, width: 2),
        ),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(badge, style: AppTextStyles.chip),
                      ),
                    ),
                    const Spacer(),
                    Text(transfers, style: AppTextStyles.caption),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.end,
                  spacing: 8,
                  children: [
                    PriceLabel(itinerary.fare, large: true),
                    Text('· $duration', style: AppTextStyles.bodyMuted),
                  ],
                ),
                const SizedBox(height: 12),
                TransportChipsRow(itinerary: itinerary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
