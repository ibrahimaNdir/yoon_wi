import 'package:dartz/dartz.dart';
import 'package:yoon_wi/core/error/failures.dart';
import 'package:yoon_wi/features/hubs/domain/repositories/hub_repository.dart';
import 'package:yoon_wi/features/itinerary/domain/engine/route_planner.dart';
import 'package:yoon_wi/features/itinerary/domain/entities/itinerary.dart';
import 'package:yoon_wi/features/itinerary/domain/repositories/itinerary_repository.dart';
import 'package:yoon_wi/features/networks/domain/repositories/network_repository.dart';
import 'package:yoon_wi/features/search/domain/entities/place.dart';
import 'package:yoon_wi/features/search/domain/entities/search_preferences.dart';

class ItineraryRepositoryImpl implements ItineraryRepository {
  ItineraryRepositoryImpl({
    required NetworkRepository networks,
    required HubRepository hubs,
    required RoutePlanner planner,
  }) : _networks = networks,
       _hubs = hubs,
       _planner = planner;

  final NetworkRepository _networks;
  final HubRepository _hubs;
  final RoutePlanner _planner;

  @override
  Future<Either<Failure, List<Itinerary>>> findItineraries({
    required Place from,
    required Place to,
    required SearchPreferences preferences,
  }) async {
    final typesResult = await _networks.getTransportTypes();
    final hubsResult = await _hubs.getHubs();

    return typesResult.fold<Either<Failure, List<Itinerary>>>(
      (failure) => Left(failure),
      (types) => hubsResult.fold<Either<Failure, List<Itinerary>>>(
        (failure) => Left(failure),
        (hubs) => Right(
          _planner.plan(
            from: from,
            to: to,
            types: types,
            hubs: hubs,
            preferences: preferences,
          ),
        ),
      ),
    );
  }
}
