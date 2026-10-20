import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:yoon_wi/core/bloc/load_state.dart';
import 'package:yoon_wi/core/di/injection_container.dart';
import 'package:yoon_wi/core/router/route_names.dart';
import 'package:yoon_wi/core/theme/app_colors.dart';
import 'package:yoon_wi/core/theme/app_text_styles.dart';
import 'package:yoon_wi/features/hubs/domain/entities/hub.dart';
import 'package:yoon_wi/features/hubs/presentation/bloc/hubs_cubit.dart';
import 'package:yoon_wi/features/networks/domain/entities/transport_type.dart';
import 'package:yoon_wi/features/networks/presentation/bloc/types_cubit.dart';
import 'package:yoon_wi/features/networks/presentation/widgets/transport_type_card.dart';
import 'package:yoon_wi/shared/widgets/empty_state.dart';
import 'package:yoon_wi/shared/widgets/loading_skeleton.dart';
import 'package:yoon_wi/shared/widgets/primary_button.dart';

class TypesPage extends StatelessWidget {
  const TypesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<TypesCubit>()..load()),
        BlocProvider(create: (_) => sl<HubsCubit>()..load()),
      ],
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<TypesCubit, LoadState<List<TransportType>>>(
            builder: (context, state) {
              switch (state.status) {
                case LoadStatus.loading:
                  return ListView.separated(
                    padding: const EdgeInsets.all(24),
                    itemCount: 4,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, __) => const LoadingSkeleton(height: 84),
                  );
                case LoadStatus.failure:
                  return EmptyState(
                    title: 'Impossible de charger les réseaux',
                    message: state.message ?? 'Une erreur est survenue.',
                    icon: Icons.error_outline,
                    actions: [
                      PrimaryButton(
                        label: 'Réessayer',
                        onPressed: () => context.read<TypesCubit>().load(),
                      ),
                    ],
                  );
                case LoadStatus.success:
                  final types = state.data!;
                  return ListView(
                    padding: const EdgeInsets.all(24),
                    children: [
                      Semantics(
                        header: true,
                        child: const Text(
                          'Réseaux et tarifs',
                          style: AppTextStyles.h1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Touchez un type de transport pour voir ses lignes, un hub pour voir son détail.',
                        style: AppTextStyles.bodyMuted,
                      ),
                      const SizedBox(height: 16),
                      for (final type in types) ...[
                        TransportTypeCard(
                          type: type,
                          onTap:
                              () => context.go(RouteNames.linesOf(type.name)),
                        ),
                        const SizedBox(height: 12),
                      ],
                      const SizedBox(height: 8),
                      Semantics(
                        header: true,
                        child: Text(
                          'Hubs de correspondance',
                          style: AppTextStyles.h2.copyWith(fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const _HubsSection(),
                    ],
                  );
              }
            },
          ),
        ),
      ),
    );
  }
}

class _HubsSection extends StatelessWidget {
  const _HubsSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HubsCubit, LoadState<List<Hub>>>(
      builder: (context, state) {
        switch (state.status) {
          case LoadStatus.loading:
            return const LoadingSkeleton(height: 44);
          case LoadStatus.failure:
            return const Text(
              'Hubs indisponibles pour le moment.',
              style: AppTextStyles.bodyMuted,
            );
          case LoadStatus.success:
            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final hub in state.data!)
                  ActionChip(
                    label: Text(hub.name),
                    backgroundColor: AppColors.surface,
                    side: const BorderSide(color: AppColors.line),
                    onPressed: () => context.push(RouteNames.hubOf(hub.id)),
                  ),
              ],
            );
        }
      },
    );
  }
}
