import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:yoon_wi/core/bloc/load_state.dart';
import 'package:yoon_wi/core/di/injection_container.dart';
import 'package:yoon_wi/core/router/route_names.dart';
import 'package:yoon_wi/core/theme/app_text_styles.dart';
import 'package:yoon_wi/features/itinerary/domain/entities/itinerary.dart';
import 'package:yoon_wi/features/itinerary/presentation/bloc/itinerary_cubit.dart';
import 'package:yoon_wi/features/itinerary/presentation/widgets/loading_view.dart';
import 'package:yoon_wi/features/itinerary/presentation/widgets/no_result_view.dart';
import 'package:yoon_wi/features/itinerary/presentation/widgets/options_view.dart';
import 'package:yoon_wi/features/search/presentation/bloc/search_form_cubit.dart';
import 'package:yoon_wi/features/search/presentation/search_labels.dart';
import 'package:yoon_wi/shared/widgets/empty_state.dart';
import 'package:yoon_wi/shared/widgets/primary_button.dart';

class ItineraryResultsPage extends StatelessWidget {
  const ItineraryResultsPage({super.key});

  static Future<void> _run(ItineraryCubit cubit) {
    final form = sl<SearchFormCubit>().state;
    return cubit.search(
      from: form.departure!,
      to: form.arrival!,
      preferences: form.preferences,
    );
  }

  static Future<void> _editPreferences(BuildContext context) async {
    final cubit = context.read<ItineraryCubit>();
    await context.push(RouteNames.preferences);
    if (!context.mounted) return;
    await _run(cubit);
  }

  @override
  Widget build(BuildContext context) {
    final form = sl<SearchFormCubit>().state;

    // Garde-fou : on ne devrait jamais arriver ici sans deux lieux valides.
    if (!form.canSearch) {
      return Scaffold(
        appBar: AppBar(),
        body: SafeArea(child: NoResultView(onEdit: () => context.pop())),
      );
    }

    return BlocProvider(
      create:
          (_) =>
              sl<ItineraryCubit>()..search(
                from: form.departure!,
                to: form.arrival!,
                preferences: form.preferences,
              ),
      child: Builder(
        builder:
            (context) => Scaffold(
              appBar: AppBar(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${form.departure!.name} → ${form.arrival!.name}',
                      style: AppTextStyles.h2.copyWith(fontSize: 17),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      timeShortLabel(form.time),
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
                actions: [
                  TextButton.icon(
                    onPressed: () => _editPreferences(context),
                    icon: const Icon(Icons.tune, size: 18),
                    label: const Text('Préférences'),
                  ),
                ],
              ),
              body: SafeArea(
                child: BlocBuilder<ItineraryCubit, LoadState<List<Itinerary>>>(
                  builder: (context, state) {
                    switch (state.status) {
                      case LoadStatus.loading:
                        return LoadingView(onCancel: () => context.pop());
                      case LoadStatus.failure:
                        return EmptyState(
                          icon: Icons.error_outline,
                          title: 'Calcul impossible',
                          message: state.message ?? 'Une erreur est survenue.',
                          actions: [
                            PrimaryButton(
                              label: 'Réessayer',
                              onPressed:
                                  () => _run(context.read<ItineraryCubit>()),
                            ),
                          ],
                        );
                      case LoadStatus.success:
                        final itineraries = state.data!;
                        if (itineraries.isEmpty) {
                          return NoResultView(
                            onEdit: () => context.pop(),
                            onPreferences: () => _editPreferences(context),
                          );
                        }
                        return OptionsView(
                          itineraries: itineraries,
                          onSelect:
                              (itinerary) => context.push(
                                RouteNames.roadmap,
                                extra: itinerary,
                              ),
                        );
                    }
                  },
                ),
              ),
            ),
      ),
    );
  }
}
