import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:yoon_wi/core/bloc/load_state.dart';
import 'package:yoon_wi/core/di/injection_container.dart';
import 'package:yoon_wi/core/router/route_names.dart';
import 'package:yoon_wi/core/theme/app_text_styles.dart';
import 'package:yoon_wi/core/utils/duration_formatter.dart';
import 'package:yoon_wi/core/utils/price_formatter.dart';
import 'package:yoon_wi/features/history/domain/entities/trip_history_entry.dart';
import 'package:yoon_wi/features/history/presentation/bloc/history_cubit.dart';
import 'package:yoon_wi/features/history/presentation/history_labels.dart';
import 'package:yoon_wi/features/history/presentation/open_history_trip.dart';
import 'package:yoon_wi/shared/widgets/empty_state.dart';
import 'package:yoon_wi/shared/widgets/loading_skeleton.dart';
import 'package:yoon_wi/shared/widgets/primary_button.dart';
import 'package:yoon_wi/shared/widgets/secondary_button.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  Future<void> _confirmClear(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Effacer l’historique ?'),
        content: const Text(
            'Tous les trajets récents seront supprimés de ce téléphone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Effacer'),
          ),
        ],
      ),
    );
    if (confirmed == true) await sl<HistoryCubit>().clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Historique')),
      body: SafeArea(
        child: BlocBuilder<HistoryCubit, LoadState<List<TripHistoryEntry>>>(
          bloc: sl<HistoryCubit>(),
          builder: (context, state) {
            switch (state.status) {
              case LoadStatus.loading:
                return ListView(
                  padding: const EdgeInsets.all(24),
                  children: const [
                    LoadingSkeleton(height: 60),
                    SizedBox(height: 12),
                    LoadingSkeleton(height: 60),
                  ],
                );
              case LoadStatus.failure:
                return EmptyState(
                  icon: Icons.error_outline,
                  title: 'Historique indisponible',
                  message: state.message ?? 'Une erreur est survenue.',
                  actions: [
                    PrimaryButton(
                      label: 'Réessayer',
                      onPressed: () => sl<HistoryCubit>().load(),
                    ),
                  ],
                );
              case LoadStatus.success:
                final entries = state.data!;
                if (entries.isEmpty) {
                  return EmptyState(
                    icon: Icons.history,
                    title: 'Aucun trajet pour l’instant',
                    message:
                    'Les trajets que vous consultez apparaîtront ici.',
                    actions: [
                      PrimaryButton(
                        label: 'Faire une recherche',
                        onPressed: () => context.go(RouteNames.search),
                      ),
                    ],
                  );
                }
                final now = DateTime.now();
                final groups = <HistoryGroup, List<TripHistoryEntry>>{};
                for (final entry in entries) {
                  groups
                      .putIfAbsent(groupOf(entry.at, now), () => [])
                      .add(entry);
                }
                return Column(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                        children: [
                          for (final group in HistoryGroup.values)
                            if (groups.containsKey(group)) ...[
                              Padding(
                                padding:
                                const EdgeInsets.fromLTRB(0, 12, 0, 4),
                                child: Semantics(
                                  header: true,
                                  child: Text(groupLabel(group),
                                      style: AppTextStyles.caption),
                                ),
                              ),
                              for (final entry in groups[group]!)
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(
                                      '${entry.from.name} → ${entry.to.name}',
                                      style: AppTextStyles.body),
                                  subtitle: Text(
                                    '${PriceFormatter.format(entry.fare)} · '
                                        '${DurationFormatter.range(entry.minMinutes, entry.maxMinutes)}',
                                    style: AppTextStyles.bodyMuted,
                                  ),
                                  trailing: Text(timeLabel(entry.at, group),
                                      style: AppTextStyles.caption),
                                  onTap: () => openHistoryTrip(context, entry),
                                ),
                            ],
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: SecondaryButton(
                        label: 'Effacer l’historique',
                        onPressed: () => _confirmClear(context),
                      ),
                    ),
                  ],
                );
            }
          },
        ),
      ),
    );
  }
}