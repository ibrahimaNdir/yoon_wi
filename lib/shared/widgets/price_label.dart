import 'package:flutter/material.dart';
import 'package:yoon_wi/core/theme/app_text_styles.dart';
import 'package:yoon_wi/core/utils/price_formatter.dart';

class PriceLabel extends StatelessWidget {
  const PriceLabel(this.amount, {super.key, this.large = false});

  final int amount;
  final bool large;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: PriceFormatter.format(amount, withCurrency: false),
            style: large ? AppTextStyles.price : AppTextStyles.priceSmall,
          ),
          const TextSpan(text: '\u00A0FCFA', style: AppTextStyles.bodyMuted),
        ],
      ),
    );
  }
}
