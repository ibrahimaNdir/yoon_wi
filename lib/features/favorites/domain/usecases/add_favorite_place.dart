import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:yoon_wi/core/error/failures.dart';
import 'package:yoon_wi/core/usecases/usecase.dart';
import 'package:yoon_wi/features/favorites/domain/entities/favorites.dart';
import 'package:yoon_wi/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:yoon_wi/features/search/domain/entities/place.dart';

class AddFavoritePlaceParams extends Equatable {
  const AddFavoritePlaceParams({required this.label, required this.place});
  final String label;
  final Place place;

  @override
  List<Object> get props => [label, place];
}

class AddFavoritePlace extends UseCase<Favorites, AddFavoritePlaceParams> {
  AddFavoritePlace(this._repository);
  final FavoritesRepository _repository;

  @override
  Future<Either<Failure, Favorites>> call(AddFavoritePlaceParams p) =>
      _repository.addPlace(p.label, p.place);
}
