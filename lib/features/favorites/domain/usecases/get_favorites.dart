import 'package:dartz/dartz.dart';
import 'package:yoon_wi/core/error/failures.dart';
import 'package:yoon_wi/core/usecases/usecase.dart';
import 'package:yoon_wi/features/favorites/domain/entities/favorites.dart';
import 'package:yoon_wi/features/favorites/domain/repositories/favorites_repository.dart';

class GetFavorites extends UseCase<Favorites, NoParams> {
  GetFavorites(this._repository);
  final FavoritesRepository _repository;

  @override
  Future<Either<Failure, Favorites>> call(NoParams params) =>
      _repository.getFavorites();
}
