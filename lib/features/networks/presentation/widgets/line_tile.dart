import 'package:flutter/material.dart';
import 'package:yoon_wi/core/theme/app_colors.dart';
import 'package:yoon_wi/core/theme/app_text_styles.dart';
import 'package:yoon_wi/core/utils/plural.dart';
import 'package:yoon_wi/features/networks/domain/entities/line.dart';

class LineTile extends StatelessWidget {
  const LineTile({
    super.key,
    required this.line,
    required this.color,
    required this.onTap,
  });

  final Line line;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final stops = plural(line.stops.length, 'arrêt');
    return Semantics(
      button: true,
      label: '${line.name}, $stops',
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
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 60),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(width: 6, color: color),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                line.name,
                                style: AppTextStyles.h2.copyWith(fontSize: 17),
                              ),
                            ),
                            Text(stops, style: AppTextStyles.bodyMuted),
                            const Icon(
                              Icons.chevron_right,
                              color: AppColors.muted,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
