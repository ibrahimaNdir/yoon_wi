import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yoon_wi/core/bloc/load_state.dart';
import 'package:yoon_wi/core/error/failures.dart';
import 'package:yoon_wi/core/usecases/usecase.dart';
import 'package:yoon_wi/features/favorites/domain/entities/favorites.dart';
import 'package:yoon_wi/features/favorites/domain/usecases/add_favorite_place.dart';
import 'package:yoon_wi/features/favorites/domain/usecases/get_favorites.dart';
import 'package:yoon_wi/features/favorites/domain/usecases/remove_favorite.dart';
import 'package:yoon_wi/features/favorites/domain/usecases/save_trip.dart';
import 'package:yoon_wi/features/search/domain/entities/place.dart';

/// Partagé par l'onglet Favoris et l'étoile de la feuille de route
/// (enregistré comme singleton).
class FavoritesCubit extends Cubit<LoadState<Favorites>> {
  FavoritesCubit({
    required GetFavorites getFavorites,
    required AddFavoritePlace addPlace,
    required RemoveFavoritePlace removePlace,
    required SaveTrip saveTrip,
    required RemoveSavedTrip removeTrip,
  }) : _get = getFavorites,
       _addPlace = addPlace,
       _removePlace = removePlace,
       _saveTrip = saveTrip,
       _removeTrip = removeTrip,
       super(const LoadState.loading());

  final GetFavorites _get;
  final AddFavoritePlace _addPlace;
  final RemoveFavoritePlace _removePlace;
  final SaveTrip _saveTrip;
  final RemoveSavedTrip _removeTrip;

  Future<void> load() async {
    emit(const LoadState.loading());
    _emit(await _get(const NoParams()));
  }

  Future<void> addPlace(String label, Place place) async => _emit(
    await _addPlace(AddFavoritePlaceParams(label: label, place: place)),
  );

  Future<void> removePlace(String label) async =>
      _emit(await _removePlace(label));

  Future<void> removeTrip(String id) async => _emit(await _removeTrip(id));

  /// Étoile de la feuille de route : enregistre ou retire le trajet.
  Future<void> toggleTrip(Place from, Place to) async {
    final current = state.data ?? Favorites.empty;
    if (current.isTripSaved(from.id, to.id)) {
      _emit(await _removeTrip('${from.id}>${to.id}'));
    } else {
      _emit(await _saveTrip(SaveTripParams(from: from, to: to)));
    }
  }

  void _emit(Either<Failure, Favorites> result) {
    if (isClosed) return;
    result.fold(
      (failure) => emit(LoadState.failure(failure.message)),
      (favorites) => emit(LoadState.success(favorites)),
    );
  }
}
