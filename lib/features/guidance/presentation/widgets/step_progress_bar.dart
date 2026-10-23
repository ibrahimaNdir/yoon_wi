import 'package:flutter/material.dart';
import 'package:yoon_wi/core/theme/app_colors.dart';
import 'package:yoon_wi/core/theme/app_text_styles.dart';

class StepProgressBar extends StatelessWidget {
  const StepProgressBar({
    super.key,
    required this.index,
    required this.total,
    required this.color,
  });

  /// Étape en cours, en partant de 0.
  final int index;
  final int total;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final label = 'Étape ${index + 1} sur $total';
    return Semantics(
      label: label,
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.caption),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (index + 1) / total,
              minHeight: 8,
              color: color,
              backgroundColor: AppColors.line,
            ),
          ),
        ],
      ),
    );
  }
}
