import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:yoon_wi/core/bloc/load_state.dart';
import 'package:yoon_wi/core/di/injection_container.dart';
import 'package:yoon_wi/core/router/route_names.dart';
import 'package:yoon_wi/core/theme/app_text_styles.dart';
import 'package:yoon_wi/core/utils/price_formatter.dart';
import 'package:yoon_wi/features/history/domain/entities/trip_history_entry.dart';
import 'package:yoon_wi/features/history/presentation/bloc/history_cubit.dart';
import 'package:yoon_wi/features/history/presentation/open_history_trip.dart';

class RecentTripsList extends StatelessWidget {
  const RecentTripsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryCubit, LoadState<List<TripHistoryEntry>>>(
      bloc: sl<HistoryCubit>(),
      builder: (context, state) {
        final entries = state.data;
        if (state.status != LoadStatus.success ||
            entries == null ||
            entries.isEmpty) {
          return const SizedBox.shrink();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Semantics(
                    header: true,
                    child: Text('Trajets récents',
                        style: AppTextStyles.h2.copyWith(fontSize: 16)),
                  ),
                ),
                TextButton(
                  onPressed: () => context.push(RouteNames.history),
                  child: const Text('Voir tout'),
                ),
              ],
            ),
            for (final entry in entries.take(2))
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('${entry.from.name} → ${entry.to.name}',
                    style: AppTextStyles.body),
                trailing: Text(PriceFormatter.format(entry.fare),
                    style: AppTextStyles.bodyMuted),
                onTap: () => openHistoryTrip(context, entry),
              ),
          ],
        );
      },
    );
  }
}