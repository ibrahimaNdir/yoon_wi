import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:yoon_wi/core/di/injection_container.dart';
import 'package:yoon_wi/core/router/route_names.dart';
import 'package:yoon_wi/core/theme/app_colors.dart';
import 'package:yoon_wi/core/theme/app_text_styles.dart';
import 'package:yoon_wi/features/onboarding/presentation/bloc/onboarding_cubit.dart';
import 'package:yoon_wi/features/onboarding/presentation/bloc/onboarding_state.dart';
import 'package:yoon_wi/shared/widgets/primary_button.dart';
import 'package:yoon_wi/shared/widgets/secondary_button.dart';

class PermissionsPage extends StatelessWidget {
  const PermissionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<OnboardingCubit>(),
      child: BlocConsumer<OnboardingCubit, OnboardingState>(
        listenWhen:
            (previous, current) => current.status == OnboardingStatus.done,
        listener: (context, state) => context.go(RouteNames.search),
        builder: (context, state) {
          final loading = state.status == OnboardingStatus.loading;
          final cubit = context.read<OnboardingCubit>();
          return Scaffold(
            body: SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Semantics(
                            header: true,
                            child: const Text(
                              'Avant de commencer',
                              style: AppTextStyles.h1,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Deux autorisations rendent Yoon Wi plus utile. Vous pouvez les refuser et saisir vos lieux à la main.',
                            style: AppTextStyles.bodyMuted,
                          ),
                          const SizedBox(height: 24),
                          const _PermissionCard(
                            icon: Icons.my_location,
                            title: 'Localisation',
                            text:
                                'Pour trouver l’arrêt le plus proche et vous guider pendant le trajet. Utilisée quand l’appli est ouverte.',
                          ),
                          const SizedBox(height: 12),
                          const _PermissionCard(
                            icon: Icons.notifications_none,
                            title: 'Notifications',
                            text:
                                'Pour vous prévenir d’une perturbation sur votre ligne et du moment de descendre.',
                          ),
                          const Spacer(),
                          const SizedBox(height: 24),
                          PrimaryButton(
                            label: 'Continuer',
                            isLoading: loading,
                            onPressed: () => cubit.finish(askPermissions: true),
                          ),
                          const SizedBox(height: 12),
                          SecondaryButton(
                            label: 'Plus tard',
                            onPressed:
                                loading
                                    ? null
                                    : () => cubit.finish(askPermissions: false),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PermissionCard extends StatelessWidget {
  const _PermissionCard({
    required this.icon,
    required this.title,
    required this.text,
  });

  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.h2.copyWith(fontSize: 17)),
                const SizedBox(height: 6),
                Text(text, style: AppTextStyles.bodyMuted),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
