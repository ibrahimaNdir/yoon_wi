import 'package:dartz/dartz.dart';
import 'package:yoon_wi/core/error/failures.dart';
import 'package:yoon_wi/features/favorites/data/datasources/favorites_local_datasource.dart';
import 'package:yoon_wi/features/favorites/domain/entities/favorite_place.dart';
import 'package:yoon_wi/features/favorites/domain/entities/favorites.dart';
import 'package:yoon_wi/features/favorites/domain/entities/saved_trip.dart';
import 'package:yoon_wi/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:yoon_wi/features/search/domain/entities/place.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  FavoritesRepositoryImpl(this._local);
  final FavoritesLocalDataSource _local;

  Future<Either<Failure, Favorites>> _update(
    Favorites Function(Favorites current) change,
  ) async {
    try {
      final updated = change(await _local.read());
      await _local.write(updated);
      return Right(updated);
    } catch (_) {
      return const Left(LocalFailure('Enregistrement impossible.'));
    }
  }

  @override
  Future<Either<Failure, Favorites>> getFavorites() async {
    try {
      return Right(await _local.read());
    } catch (_) {
      return const Left(LocalFailure('Favoris indisponibles.'));
    }
  }

  @override
  Future<Either<Failure, Favorites>> addPlace(String label, Place place) =>
      _update(
        (f) => f.copyWith(
          places: [
            ...f.places.where((p) => p.label != label),
            FavoritePlace(label: label, place: place),
          ],
        ),
      );

  @override
  Future<Either<Failure, Favorites>> removePlace(String label) => _update(
    (f) => f.copyWith(places: f.places.where((p) => p.label != label).toList()),
  );

  @override
  Future<Either<Failure, Favorites>> saveTrip(Place from, Place to) =>
      _update((f) {
        final trip = SavedTrip(from: from, to: to);
        if (f.trips.any((t) => t.id == trip.id)) return f;
        return f.copyWith(trips: [trip, ...f.trips]);
      });

  @override
  Future<Either<Failure, Favorites>> removeTrip(String id) => _update(
    (f) => f.copyWith(trips: f.trips.where((t) => t.id != id).toList()),
  );
}
