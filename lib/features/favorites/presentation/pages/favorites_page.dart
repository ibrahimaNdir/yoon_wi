import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:yoon_wi/core/bloc/load_state.dart';
import 'package:yoon_wi/core/di/injection_container.dart';
import 'package:yoon_wi/core/router/route_names.dart';
import 'package:yoon_wi/core/theme/app_colors.dart';
import 'package:yoon_wi/core/theme/app_text_styles.dart';
import 'package:yoon_wi/features/favorites/domain/entities/favorite_place.dart';
import 'package:yoon_wi/features/favorites/domain/entities/favorites.dart';
import 'package:yoon_wi/features/favorites/domain/entities/saved_trip.dart';
import 'package:yoon_wi/features/favorites/presentation/bloc/favorites_cubit.dart';
import 'package:yoon_wi/features/search/domain/entities/place.dart';
import 'package:yoon_wi/features/search/presentation/bloc/search_form_cubit.dart';
import 'package:yoon_wi/features/search/presentation/bloc/search_form_state.dart';
import 'package:yoon_wi/shared/widgets/empty_state.dart';
import 'package:yoon_wi/shared/widgets/loading_skeleton.dart';
import 'package:yoon_wi/shared/widgets/primary_button.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  static const _labels = ['Maison', 'Études', 'Travail'];

  Future<void> _addPlace(BuildContext context) async {
    final label = await showDialog<String>(
      context: context,
      builder:
          (dialogContext) => SimpleDialog(
            title: const Text('Quel type de lieu ?'),
            children: [
              for (final l in _labels)
                SimpleDialogOption(
                  onPressed: () => Navigator.of(dialogContext).pop(l),
                  child: Text(l, style: AppTextStyles.body),
                ),
            ],
          ),
    );
    if (label == null || !context.mounted) return;
    final cubit = sl<FavoritesCubit>();
    await context.push<void>(
      RouteNames.favoritePicker,
      extra: (Place place) => cubit.addPlace(label, place),
    );
  }

  void _goTo(BuildContext context, Place place) {
    sl<SearchFormCubit>().setPlace(SearchField.to, place);
    context.go(RouteNames.search);
  }

  void _runTrip(BuildContext context, SavedTrip trip) {
    final form = sl<SearchFormCubit>();
    form.setPlace(SearchField.from, trip.from);
    form.setPlace(SearchField.to, trip.to);
    context.go(RouteNames.results);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<FavoritesCubit>(),
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<FavoritesCubit, LoadState<Favorites>>(
            builder: (context, state) {
              switch (state.status) {
                case LoadStatus.loading:
                  return ListView(
                    padding: const EdgeInsets.all(24),
                    children: const [
                      LoadingSkeleton(height: 70),
                      SizedBox(height: 12),
                      LoadingSkeleton(height: 70),
                    ],
                  );
                case LoadStatus.failure:
                  return EmptyState(
                    icon: Icons.error_outline,
                    title: 'Favoris indisponibles',
                    message: state.message ?? 'Une erreur est survenue.',
                    actions: [
                      PrimaryButton(
                        label: 'Réessayer',
                        onPressed: () => context.read<FavoritesCubit>().load(),
                      ),
                    ],
                  );
                case LoadStatus.success:
                  final favorites = state.data!;
                  return ListView(
                    padding: const EdgeInsets.all(24),
                    children: [
                      Semantics(
                        header: true,
                        child: const Text('Favoris', style: AppTextStyles.h1),
                      ),
                      const SizedBox(height: 16),
                      Semantics(
                        header: true,
                        child: Text(
                          'Lieux',
                          style: AppTextStyles.h2.copyWith(fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (favorites.places.isEmpty)
                        const Text(
                          'Ajoutez votre maison, votre lieu d’études ou de travail pour les retrouver en un geste.',
                          style: AppTextStyles.bodyMuted,
                        )
                      else
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            for (final fav in favorites.places)
                              _PlaceCard(
                                favorite: fav,
                                onTap: () => _goTo(context, fav.place),
                                onRemove:
                                    () => context
                                        .read<FavoritesCubit>()
                                        .removePlace(fav.label),
                              ),
                          ],
                        ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: () => _addPlace(context),
                        icon: const Icon(Icons.add),
                        label: const Text('Ajouter un lieu'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.line),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Semantics(
                        header: true,
                        child: Text(
                          'Trajets enregistrés',
                          style: AppTextStyles.h2.copyWith(fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (favorites.trips.isEmpty)
                        const Text(
                          'Touchez l’étoile sur une feuille de route pour enregistrer un trajet.',
                          style: AppTextStyles.bodyMuted,
                        )
                      else
                        for (final trip in favorites.trips)
                          _TripTile(
                            trip: trip,
                            onTap: () => _runTrip(context, trip),
                            onRemove:
                                () => context.read<FavoritesCubit>().removeTrip(
                                  trip.id,
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

class _PlaceCard extends StatelessWidget {
  const _PlaceCard({
    required this.favorite,
    required this.onTap,
    required this.onRemove,
  });

  final FavoritePlace favorite;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 150, maxWidth: 240),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.line),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Semantics(
                button: true,
                label: 'Aller à ${favorite.place.name}, ${favorite.label}',
                excludeSemantics: true,
                onTap: onTap,
                child: InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.circular(14),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 12, 4, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(favorite.label, style: AppTextStyles.caption),
                        const SizedBox(height: 2),
                        Text(
                          favorite.place.name,
                          style: AppTextStyles.body.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
              tooltip: 'Retirer ${favorite.label}',
              icon: const Icon(Icons.close, size: 18),
              onPressed: onRemove,
            ),
          ],
        ),
      ),
    );
  }
}

class _TripTile extends StatelessWidget {
  const _TripTile({
    required this.trip,
    required this.onTap,
    required this.onRemove,
  });

  final SavedTrip trip;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final label = '${trip.from.name} → ${trip.to.name}';
    return ListTile(
      contentPadding: EdgeInsets.zero,
      minVerticalPadding: 8,
      leading: const Icon(Icons.star, color: AppColors.accent),
      title: Text(label, style: AppTextStyles.body),
      onTap: onTap,
      trailing: IconButton(
        tooltip: 'Retirer $label',
        icon: const Icon(Icons.delete_outline),
        onPressed: onRemove,
      ),
    );
  }
}
