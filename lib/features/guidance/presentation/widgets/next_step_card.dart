import 'package:flutter/material.dart';
import 'package:yoon_wi/core/theme/app_colors.dart';
import 'package:yoon_wi/core/theme/app_text_styles.dart';
import 'package:yoon_wi/features/itinerary/presentation/roadmap_labels.dart';

class NextStepCard extends StatelessWidget {
  const NextStepCard({super.key, required this.next});

  /// Null à la dernière étape.
  final StepView? next;

  @override
  Widget build(BuildContext context) {
    final text =
        next == null ? 'C’est la dernière étape.' : 'Ensuite : ${next!.title}';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: [
          const ExcludeSemantics(
            child: Icon(Icons.arrow_forward, size: 20, color: AppColors.muted),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: AppTextStyles.bodyMuted)),
        ],
      ),
    );
  }
}
