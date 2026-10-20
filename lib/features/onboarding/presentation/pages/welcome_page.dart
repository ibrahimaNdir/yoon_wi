import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yoon_wi/core/router/route_names.dart';
import 'package:yoon_wi/core/theme/app_colors.dart';
import 'package:yoon_wi/core/theme/app_text_styles.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  static const _points = [
    'Le trajet le moins cher en FCFA',
    'Le trajet le plus rapide, sans embouteillages',
    'Chaque étape expliquée, de la marche à l’arrivée',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/icons/logo.png',
                          width: 48,
                          height: 48,
                          errorBuilder:
                              (context, error, stackTrace) => const Icon(
                                Icons.route,
                                color: Colors.white,
                                size: 48,
                              ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Yoon Wi',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Semantics(
                      header: true,
                      child: const Text(
                        'Le chemin, simplement.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          height: 1.05,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Dakar en TER, BRT, Tata et Dem Dikk, avec le prix et la durée avant de partir.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    for (final point in _points)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: AppColors.accent,
                              size: 22,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                point,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const Spacer(),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => context.go(RouteNames.permissions),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: AppColors.ink,
                        textStyle: AppTextStyles.button.copyWith(fontSize: 17),
                      ),
                      child: const Text('Commencer'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
