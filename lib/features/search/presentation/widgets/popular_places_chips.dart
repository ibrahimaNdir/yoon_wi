import 'package:flutter/material.dart';
import 'package:yoon_wi/core/theme/app_colors.dart';
import 'package:yoon_wi/features/search/domain/entities/place.dart';

class PopularPlacesChips extends StatelessWidget {
  const PopularPlacesChips({
    super.key,
    required this.places,
    required this.onSelected,
  });

  final List<Place> places;
  final ValueChanged<Place> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final place in places)
          ActionChip(
            label: Text(place.name),
            backgroundColor: AppColors.surface,
            side: const BorderSide(color: AppColors.line),
            onPressed: () => onSelected(place),
          ),
      ],
    );
  }
}
