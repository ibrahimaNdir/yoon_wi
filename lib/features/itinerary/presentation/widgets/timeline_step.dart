import 'package:flutter/material.dart';
import 'package:yoon_wi/core/theme/app_colors.dart';
import 'package:yoon_wi/core/theme/app_text_styles.dart';
import 'package:yoon_wi/features/itinerary/presentation/roadmap_labels.dart';

class TimelineStep extends StatelessWidget {
  const TimelineStep({
    super.key,
    required this.view,
    required this.isLast,
    this.onAction,
  });

  final StepView view;
  final bool isLast;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ExcludeSemantics(
            child: SizedBox(
              width: 24,
              child: Column(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.background,
                      border: Border.all(color: view.color, width: 4),
                    ),
                  ),
                  if (!isLast)
                    Expanded(child: Container(width: 2, color: AppColors.line)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    view.label.toUpperCase(),
                    style: AppTextStyles.caption.copyWith(
                      color: view.color,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    view.title,
                    style: AppTextStyles.h2.copyWith(fontSize: 16),
                  ),
                  if (view.subtitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(view.subtitle, style: AppTextStyles.bodyMuted),
                  ],
                  if (view.actionLabel != null && onAction != null)
                    TextButton(
                      onPressed: onAction,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(48, 44),
                        alignment: Alignment.centerLeft,
                      ),
                      child: Text(view.actionLabel!),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
