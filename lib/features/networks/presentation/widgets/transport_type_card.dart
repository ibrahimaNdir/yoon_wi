import 'package:flutter/material.dart';
import 'package:yoon_wi/core/theme/app_colors.dart';
import 'package:yoon_wi/core/theme/app_text_styles.dart';
import 'package:yoon_wi/core/utils/plural.dart';
import 'package:yoon_wi/features/networks/domain/entities/transport_type.dart';
import 'package:yoon_wi/shared/widgets/price_label.dart';
import 'package:yoon_wi/shared/widgets/transport_chip.dart';

class TransportTypeCard extends StatelessWidget {
  const TransportTypeCard({super.key, required this.type, required this.onTap});

  final TransportType type;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final hasLines = type.lines.isNotEmpty;
    final count =
        hasLines ? plural(type.lines.length, 'ligne') : 'Aucune ligne';
    return Semantics(
      button: true,
      label: '${type.name}, $count',
      excludeSemantics: true,
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.line),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TransportChip(type.mode),
                        const SizedBox(height: 8),
                        Text(count, style: AppTextStyles.bodyMuted),
                      ],
                    ),
                  ),
                  if (hasLines)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('dès', style: AppTextStyles.caption),
                        PriceLabel(type.minFare),
                      ],
                    ),
                  const SizedBox(width: 8),
                  const Icon(Icons.chevron_right, color: AppColors.muted),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
