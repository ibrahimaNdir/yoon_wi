import 'package:flutter/material.dart';
import 'package:yoon_wi/core/theme/app_colors.dart';
import 'package:yoon_wi/core/utils/duration_formatter.dart';
import 'package:yoon_wi/core/utils/price_formatter.dart';

class CostSummaryBanner extends StatelessWidget {
  const CostSummaryBanner({
    super.key,
    required this.fare,
    required this.minMinutes,
    required this.maxMinutes,
  });

  final int fare;
  final int minMinutes;
  final int maxMinutes;

  @override
  Widget build(BuildContext context) {
    final price = PriceFormatter.format(fare);
    final duration = DurationFormatter.range(minMinutes, maxMinutes);
    return Semantics(
      label: 'Coût total $price, durée estimée $duration',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Coût total',
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                  Text(
                    price,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  'Durée estimée',
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
                Text(
                  duration,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
