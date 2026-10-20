import 'package:flutter/material.dart';
import 'package:yoon_wi/core/theme/app_colors.dart';
import 'package:yoon_wi/core/theme/app_text_styles.dart';
import 'package:yoon_wi/core/utils/duration_formatter.dart';
import 'package:yoon_wi/features/hubs/domain/entities/hub.dart';
import 'package:yoon_wi/shared/widgets/transport_chip.dart';

class TransferWalkTile extends StatelessWidget {
  const TransferWalkTile({super.key, required this.transfer});

  final Transfer transfer;

  @override
  Widget build(BuildContext context) {
    final t = transfer;
    return Semantics(
      label:
          'De ${t.from.label} vers ${t.to.label} : '
          '${t.walkMinutes} minutes de marche',
      excludeSemantics: true,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                TransportChip(t.from),
                const Icon(
                  Icons.arrow_forward,
                  size: 18,
                  color: AppColors.muted,
                ),
                TransportChip(t.to),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${DurationFormatter.minutes(t.walkMinutes)} de marche',
              style: AppTextStyles.bodyMuted,
            ),
          ],
        ),
      ),
    );
  }
}
