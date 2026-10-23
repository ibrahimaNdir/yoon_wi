import 'package:dartz/dartz.dart';
import 'package:yoon_wi/core/error/failures.dart';
import 'package:yoon_wi/features/favorites/domain/entities/favorites.dart';
import 'package:yoon_wi/features/search/domain/entities/place.dart';

/// Chaque modification renvoie les favoris à jour.
abstract class FavoritesRepository {
  Future<Either<Failure, Favorites>> getFavorites();
  Future<Either<Failure, Favorites>> addPlace(String label, Place place);
  Future<Either<Failure, Favorites>> removePlace(String label);
  Future<Either<Failure, Favorites>> saveTrip(Place from, Place to);
  Future<Either<Failure, Favorites>> removeTrip(String id);
}
