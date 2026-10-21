import 'package:dartz/dartz.dart';
import 'package:yoon_wi/core/error/failures.dart';
import 'package:yoon_wi/features/itinerary/domain/entities/itinerary.dart';
import 'package:yoon_wi/features/search/domain/entities/place.dart';
import 'package:yoon_wi/features/search/domain/entities/search_preferences.dart';

abstract class ItineraryRepository {
  /// Une liste vide veut dire « aucun itinéraire », pas une erreur.
  Future<Either<Failure, List<Itinerary>>> findItineraries({
    required Place from,
    required Place to,
    required SearchPreferences preferences,
  });
}
