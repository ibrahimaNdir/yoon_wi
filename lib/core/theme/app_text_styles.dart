import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const h1 = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w700,
    color: AppColors.ink,
    height: 1.15,
  );
  static const h2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.ink,
  );
  static const body = TextStyle(
    fontSize: 16,
    color: AppColors.ink,
    height: 1.4,
  );
  static const bodyMuted = TextStyle(
    fontSize: 14,
    color: AppColors.muted,
    height: 1.4,
  );
  static const caption = TextStyle(fontSize: 13, color: AppColors.muted);
  static const button = TextStyle(fontSize: 16, fontWeight: FontWeight.w700);
  static const chip = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );
  static const price = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.ink,
  );
  static const priceSmall = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w700,
    color: AppColors.ink,
  );
}
