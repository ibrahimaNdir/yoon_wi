import 'package:flutter/material.dart';
import 'package:yoon_wi/core/theme/app_colors.dart';
import 'package:yoon_wi/core/theme/app_text_styles.dart';

class StopTimelineTile extends StatelessWidget {
  const StopTimelineTile({
    super.key,
    required this.name,
    required this.color,
    required this.index,
    required this.total,
  });

  final String name;
  final Color color;
  final int index;
  final int total;

  @override
  Widget build(BuildContext context) {
    final isLast = index == total;
    return MergeSemantics(
      child: Semantics(
        label: 'Arrêt $index sur $total : $name',
        child: ExcludeSemantics(
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: 24,
                  child: Column(
                    children: [
                      Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.surface,
                          border: Border.all(color: color, width: 3),
                        ),
                      ),
                      if (!isLast)
                        Expanded(child: Container(width: 2, color: color)),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(name, style: AppTextStyles.body),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
