import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:yoon_wi/core/bloc/load_state.dart';
import 'package:yoon_wi/core/di/injection_container.dart';
import 'package:yoon_wi/core/theme/app_colors.dart';
import 'package:yoon_wi/core/theme/app_text_styles.dart';
import 'package:yoon_wi/features/hubs/domain/entities/hub.dart';
import 'package:yoon_wi/features/hubs/presentation/bloc/hub_cubit.dart';
import 'package:yoon_wi/features/hubs/presentation/widgets/transfer_walk_tile.dart';
import 'package:yoon_wi/shared/widgets/empty_state.dart';
import 'package:yoon_wi/shared/widgets/loading_skeleton.dart';
import 'package:yoon_wi/shared/widgets/primary_button.dart';
import 'package:yoon_wi/shared/widgets/transport_chip.dart';

class HubPage extends StatelessWidget {
  const HubPage({super.key, required this.hubId});

  final String hubId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HubCubit>()..load(hubId),
      child: Scaffold(
        appBar: AppBar(title: const Text('Hub de correspondance')),
        body: SafeArea(
          child: BlocBuilder<HubCubit, LoadState<Hub>>(
            builder: (context, state) {
              switch (state.status) {
                case LoadStatus.loading:
                  return ListView(
                    padding: const EdgeInsets.all(24),
                    children: const [
                      LoadingSkeleton(height: 40),
                      SizedBox(height: 16),
                      LoadingSkeleton(height: 90),
                      SizedBox(height: 12),
                      LoadingSkeleton(height: 90),
                    ],
                  );
                case LoadStatus.failure:
                  return EmptyState(
                    title: 'Hub introuvable',
                    message: state.message ?? 'Une erreur est survenue.',
                    icon: Icons.error_outline,
                    actions: [
                      PrimaryButton(
                        label: 'Retour',
                        onPressed: () => context.pop(),
                      ),
                    ],
                  );
                case LoadStatus.success:
                  final hub = state.data!;
                  return ListView(
                    padding: const EdgeInsets.all(24),
                    children: [
                      Semantics(
                        header: true,
                        child: Text(
                          'Hub de ${hub.name}',
                          style: AppTextStyles.h1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Point de correspondance entre plusieurs réseaux',
                        style: AppTextStyles.bodyMuted,
                      ),
                      const SizedBox(height: 20),
                      Semantics(
                        header: true,
                        child: Text(
                          'Réseaux présents',
                          style: AppTextStyles.h2.copyWith(fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final mode in hub.networks) TransportChip(mode),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Semantics(
                        header: true,
                        child: Text(
                          'Marche entre les quais',
                          style: AppTextStyles.h2.copyWith(fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (hub.transfers.isEmpty)
                        const Text(
                          'Aucune correspondance renseignée pour ce hub.',
                          style: AppTextStyles.bodyMuted,
                        )
                      else
                        for (final transfer in hub.transfers) ...[
                          TransferWalkTile(transfer: transfer),
                          const SizedBox(height: 12),
                        ],
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.line),
                        ),
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 20,
                              color: AppColors.muted,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Aux heures de pointe, prévoyez 10 min de plus pour la correspondance.',
                                style: AppTextStyles.bodyMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
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
