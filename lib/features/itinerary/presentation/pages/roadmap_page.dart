import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yoon_wi/core/di/injection_container.dart';
import 'package:yoon_wi/core/router/route_names.dart';
import 'package:yoon_wi/core/theme/app_text_styles.dart';
import 'package:yoon_wi/features/itinerary/domain/entities/itinerary.dart';
import 'package:yoon_wi/features/itinerary/domain/entities/step.dart';
import 'package:yoon_wi/features/itinerary/presentation/pages/share_sheet.dart';
import 'package:yoon_wi/features/itinerary/presentation/roadmap_labels.dart';
import 'package:yoon_wi/features/itinerary/presentation/widgets/cost_summary_banner.dart';
import 'package:yoon_wi/features/itinerary/presentation/widgets/timeline_step.dart';
import 'package:yoon_wi/features/search/presentation/bloc/search_form_cubit.dart';
import 'package:yoon_wi/shared/widgets/empty_state.dart';
import 'package:yoon_wi/shared/widgets/primary_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yoon_wi/core/bloc/load_state.dart';
import 'package:yoon_wi/features/favorites/domain/entities/favorites.dart';
import 'package:yoon_wi/features/favorites/presentation/bloc/favorites_cubit.dart';

class RoadmapPage extends StatelessWidget {
  const RoadmapPage({super.key, required this.itinerary});

  final Itinerary? itinerary;

  void _onAction(BuildContext context, ItineraryStep step, StepAction action) {
    switch (action) {
      case StepAction.line:
        context.push(RouteNames.stopsOf(step.mode!.label, step.lineCode!));
      case StepAction.hub:
        context.push(RouteNames.hubOf(hubSlug(step.from)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final form = sl<SearchFormCubit>().state;
    final it = itinerary;
    final from = form.departure;
    final to = form.arrival;

    if (it == null || from == null || to == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Feuille de route')),
        body: SafeArea(
          child: EmptyState(
            icon: Icons.route,
            title: 'Itinéraire introuvable',
            message: 'Relancez une recherche pour obtenir la feuille de route.',
          ),
        ),
      );
    }

    final steps = it.steps;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feuille de route'),
        actions: [
          BlocBuilder<FavoritesCubit, LoadState<Favorites>>(
            bloc: sl<FavoritesCubit>(),
            builder: (context, state) {
              final saved = state.data?.isTripSaved(from.id, to.id) ?? false;
              return IconButton(
                tooltip:
                    saved
                        ? 'Retirer des trajets enregistrés'
                        : 'Enregistrer ce trajet',
                icon: Icon(saved ? Icons.star : Icons.star_border),
                onPressed: () => sl<FavoritesCubit>().toggleTrip(from, to),
              );
            },
          ),
          TextButton.icon(
            onPressed:
                () =>
                    showShareSheet(context, itinerary: it, from: from, to: to),
            icon: const Icon(Icons.share, size: 18),
            label: const Text('Partager'),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                children: [
                  Text('${from.name} → ${to.name}', style: AppTextStyles.h2),
                  const SizedBox(height: 12),
                  CostSummaryBanner(
                    fare: it.fare,
                    minMinutes: it.minMinutes,
                    maxMinutes: it.maxMinutes,
                  ),
                  const SizedBox(height: 24),
                  for (var i = 0; i < steps.length; i++)
                    Builder(
                      builder: (context) {
                        final step = steps[i];
                        final view = describeStep(step);
                        return TimelineStep(
                          view: view,
                          isLast: i == steps.length - 1,
                          onAction:
                              view.action == null
                                  ? null
                                  : () =>
                                      _onAction(context, step, view.action!),
                        );
                      },
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: PrimaryButton(
                label: 'Démarrer le guidage',
                onPressed:
                    () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Le guidage arrive à l’étape F13.'),
                      ),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
