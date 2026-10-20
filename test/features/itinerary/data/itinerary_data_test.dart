import 'package:flutter_test/flutter_test.dart';
import 'package:yoon_wi/core/data/local_json_loader.dart';
import 'package:yoon_wi/features/hubs/data/datasources/hub_local_datasource.dart';
import 'package:yoon_wi/features/hubs/data/repositories/hub_repository_impl.dart';
import 'package:yoon_wi/features/itinerary/data/repositories/itinerary_repository_impl.dart';
import 'package:yoon_wi/features/itinerary/domain/engine/route_planner.dart';
import 'package:yoon_wi/features/itinerary/domain/entities/itinerary.dart';
import 'package:yoon_wi/features/networks/data/datasources/network_local_datasource.dart';
import 'package:yoon_wi/features/networks/data/repositories/network_repository_impl.dart';
import 'package:yoon_wi/features/search/data/datasources/place_local_datasource.dart';
import 'package:yoon_wi/features/search/data/repositories/place_repository_impl.dart';
import 'package:yoon_wi/features/search/domain/entities/place.dart';
import 'package:yoon_wi/features/search/domain/entities/search_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final loader = LocalJsonLoader();
  final repository = ItineraryRepositoryImpl(
    networks: NetworkRepositoryImpl(NetworkLocalDataSourceImpl(loader)),
    hubs: HubRepositoryImpl(HubLocalDataSourceImpl(loader)),
    planner: LocalRoutePlanner(),
  );

  Future<Place> place(String name) async {
    final result =
        await PlaceRepositoryImpl(PlaceLocalDataSourceImpl(loader)).getPlaces();
    return result.getOrElse(() => <Place>[]).firstWhere((p) => p.name == name);
  }

  test('Parcelles Assainies → Sandaga avec les vrais fichiers', () async {
    final result = await repository.findItineraries(
      from: await place('Parcelles Assainies'),
      to: await place('Sandaga'),
      preferences: const SearchPreferences(),
    );

    final itineraries = result.getOrElse(() => <Itinerary>[]);
    expect(itineraries, isNotEmpty);
    expect(itineraries.first.label, ItineraryLabel.eco);
    expect(itineraries.first.fare, 300);
  });

  test('un lieu sans arrêt donne une liste vide, pas une erreur', () async {
    final result = await repository.findItineraries(
      from: await place('Parcelles Assainies'),
      to: await place('Pikine'),
      preferences: const SearchPreferences(),
    );
    expect(result.isRight(), isTrue);
    expect(result.getOrElse(() => <Itinerary>[]), isEmpty);
  });
}
