import 'package:flutter/material.dart';
import 'package:yoon_wi/core/theme/app_colors.dart';
import 'package:yoon_wi/core/theme/app_text_styles.dart';

class BreadcrumbItem {
  const BreadcrumbItem(this.label, {this.onTap});
  final String label;
  final VoidCallback? onTap;
}

class Breadcrumb extends StatelessWidget {
  const Breadcrumb({super.key, required this.items});

  final List<BreadcrumbItem> items;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: 'Fil d’Ariane',
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0)
              const ExcludeSemantics(
                child: Text('›', style: AppTextStyles.caption),
              ),
            if (i == items.length - 1)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  items[i].label,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.ink,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              )
            else
              TextButton(
                onPressed: items[i].onTap,
                style: TextButton.styleFrom(
                  minimumSize: const Size(48, 44),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                ),
                child: Text(
                  items[i].label,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
