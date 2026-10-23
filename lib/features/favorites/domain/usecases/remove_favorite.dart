import 'package:dartz/dartz.dart';
import 'package:yoon_wi/core/error/failures.dart';
import 'package:yoon_wi/core/usecases/usecase.dart';
import 'package:yoon_wi/features/favorites/domain/entities/favorites.dart';
import 'package:yoon_wi/features/favorites/domain/repositories/favorites_repository.dart';

/// Retire un lieu favori à partir de son nom ("Maison").
class RemoveFavoritePlace extends UseCase<Favorites, String> {
  RemoveFavoritePlace(this._repository);
  final FavoritesRepository _repository;

  @override
  Future<Either<Failure, Favorites>> call(String label) =>
      _repository.removePlace(label);
}

/// Retire un trajet enregistré à partir de son identifiant.
class RemoveSavedTrip extends UseCase<Favorites, String> {
  RemoveSavedTrip(this._repository);
  final FavoritesRepository _repository;

  @override
  Future<Either<Failure, Favorites>> call(String id) =>
      _repository.removeTrip(id);
}
