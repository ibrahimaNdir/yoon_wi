import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:yoon_wi/core/bloc/load_state.dart';
import 'package:yoon_wi/core/di/injection_container.dart';
import 'package:yoon_wi/core/router/route_names.dart';
import 'package:yoon_wi/core/theme/app_colors.dart';
import 'package:yoon_wi/core/theme/app_text_styles.dart';
import 'package:yoon_wi/features/search/domain/entities/place.dart';
import 'package:yoon_wi/features/search/presentation/bloc/place_search_cubit.dart';
import 'package:yoon_wi/features/search/presentation/bloc/search_form_cubit.dart';
import 'package:yoon_wi/features/search/presentation/bloc/search_form_state.dart';
import 'package:yoon_wi/features/search/presentation/search_labels.dart';
import 'package:yoon_wi/features/search/presentation/widgets/place_field.dart';
import 'package:yoon_wi/features/search/presentation/widgets/popular_places_chips.dart';
import 'package:yoon_wi/shared/widgets/primary_button.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sl<SearchFormCubit>()),
        BlocProvider(create: (_) => sl<PlaceSearchCubit>()..search('')),
      ],
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<SearchFormCubit, SearchFormState>(
            builder: (context, form) {
              return ListView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                children: [
                  const Text(
                    'Yoon Wi',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Semantics(
                    header: true,
                    child: const Text(
                      'Où allez-vous aujourd’hui ?',
                      style: AppTextStyles.h1,
                    ),
                  ),
                  const SizedBox(height: 16),
                  PlaceField(
                    label: 'Départ',
                    place: form.departure,
                    onTap: () => context.push(RouteNames.placePicker('from')),
                  ),
                  const SizedBox(height: 12),
                  PlaceField(
                    label: 'Arrivée',
                    place: form.arrival,
                    onTap: () => context.push(RouteNames.placePicker('to')),
                  ),
                  if (form.samePlace) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Le départ et l’arrivée doivent être différents.',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.danger,
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Semantics(
                          label:
                              'Heure du trajet : ${timeShortLabel(form.time)}',
                          excludeSemantics: true,
                          button: true,
                          child: OutlinedButton.icon(
                            onPressed:
                                () => context.push(RouteNames.timePicker),
                            icon: const Icon(Icons.schedule, size: 18),
                            label: Text(
                              timeShortLabel(form.time),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Semantics(
                          label:
                              'Préférences : '
                              '${priorityShortLabel(form.preferences.priority)}',
                          excludeSemantics: true,
                          button: true,
                          child: OutlinedButton.icon(
                            onPressed:
                                () => context.push(RouteNames.preferences),
                            icon: const Icon(Icons.tune, size: 18),
                            label: Text(
                              priorityShortLabel(form.preferences.priority),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  PrimaryButton(
                    label: 'Voir les itinéraires',
                    onPressed:
                        form.canSearch
                            ? () => ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Le calcul d’itinéraire arrive aux étapes F8 et F9.',
                                ),
                              ),
                            )
                            : null,
                  ),
                  const SizedBox(height: 24),
                  Semantics(
                    header: true,
                    child: Text(
                      'Repères populaires',
                      style: AppTextStyles.h2.copyWith(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 12),
                  BlocBuilder<PlaceSearchCubit, LoadState<List<Place>>>(
                    builder: (context, state) {
                      if (state.status != LoadStatus.success) {
                        return const SizedBox.shrink();
                      }
                      return PopularPlacesChips(
                        places: state.data!,
                        onSelected:
                            (place) => context
                                .read<SearchFormCubit>()
                                .fillNextEmpty(place),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
