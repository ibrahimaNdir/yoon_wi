import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:yoon_wi/core/error/failures.dart';
import 'package:yoon_wi/core/usecases/usecase.dart';
import 'package:yoon_wi/features/favorites/domain/entities/favorites.dart';
import 'package:yoon_wi/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:yoon_wi/features/search/domain/entities/place.dart';

class SaveTripParams extends Equatable {
  const SaveTripParams({required this.from, required this.to});
  final Place from;
  final Place to;

  @override
  List<Object> get props => [from, to];
}

class SaveTrip extends UseCase<Favorites, SaveTripParams> {
  SaveTrip(this._repository);
  final FavoritesRepository _repository;

  @override
  Future<Either<Failure, Favorites>> call(SaveTripParams p) =>
      _repository.saveTrip(p.from, p.to);
}
