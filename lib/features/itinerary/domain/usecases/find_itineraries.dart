import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:yoon_wi/core/error/failures.dart';
import 'package:yoon_wi/core/usecases/usecase.dart';
import 'package:yoon_wi/features/itinerary/domain/entities/itinerary.dart';
import 'package:yoon_wi/features/itinerary/domain/repositories/itinerary_repository.dart';
import 'package:yoon_wi/features/search/domain/entities/place.dart';
import 'package:yoon_wi/features/search/domain/entities/search_preferences.dart';

class FindItinerariesParams extends Equatable {
  const FindItinerariesParams({
    required this.from,
    required this.to,
    required this.preferences,
  });

  final Place from;
  final Place to;
  final SearchPreferences preferences;

  @override
  List<Object> get props => [from, to, preferences];
}

class FindItineraries extends UseCase<List<Itinerary>, FindItinerariesParams> {
  FindItineraries(this._repository);
  final ItineraryRepository _repository;

  @override
  Future<Either<Failure, List<Itinerary>>> call(FindItinerariesParams p) =>
      _repository.findItineraries(
        from: p.from,
        to: p.to,
        preferences: p.preferences,
      );
}
