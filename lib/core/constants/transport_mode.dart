import 'package:flutter/material.dart';
import 'package:yoon_wi/core/theme/app_colors.dart';

enum TransportMode {
  ter('TER', AppColors.ter),
  brt('BRT', AppColors.brt),
  tata('Bus Tata', AppColors.tata),
  ddd('Dakar Dem Dikk', AppColors.ddd),
  walk('Marche', AppColors.walk);

  const TransportMode(this.label, this.color);
  final String label;
  final Color color;
}
