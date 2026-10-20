import 'package:flutter/material.dart';
import 'package:yoon_wi/core/theme/app_colors.dart';
import 'package:yoon_wi/core/theme/app_text_styles.dart';
import 'package:yoon_wi/features/search/domain/entities/place.dart';

class PlaceField extends StatelessWidget {
  const PlaceField({
    super.key,
    required this.label,
    required this.place,
    required this.onTap,
  });

  final String label;
  final Place? place;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final border = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: const BorderSide(color: AppColors.line),
    );
    return Semantics(
      button: true,
      label: '$label : ${place?.name ?? 'à choisir'}',
      excludeSemantics: true,
      onTap: onTap,
      child: Material(
        color: AppColors.surface,
        shape: border,
        child: InkWell(
          onTap: onTap,
          customBorder: border,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 64),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(label, style: AppTextStyles.caption),
                  const SizedBox(height: 2),
                  Text(
                    place?.name ?? 'Choisir un lieu',
                    style:
                        place == null
                            ? AppTextStyles.body.copyWith(
                              color: AppColors.muted,
                            )
                            : AppTextStyles.body,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
