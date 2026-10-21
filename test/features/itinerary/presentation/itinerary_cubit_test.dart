import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yoon_wi/core/bloc/load_state.dart';
import 'package:yoon_wi/core/error/failures.dart';
import 'package:yoon_wi/features/itinerary/domain/entities/itinerary.dart';
import 'package:yoon_wi/features/itinerary/domain/usecases/find_itineraries.dart';
import 'package:yoon_wi/features/itinerary/presentation/bloc/itinerary_cubit.dart';
import 'package:yoon_wi/features/search/domain/entities/place.dart';
import 'package:yoon_wi/features/search/domain/entities/search_preferences.dart';

class MockFind extends Mock implements FindItineraries {}

void main() {
  const from = Place(id: 'a', name: 'A', zone: 'z', isPopular: true);
  const to = Place(id: 'b', name: 'B', zone: 'z', isPopular: true);
  const prefs = SearchPreferences();

  late MockFind find;

  setUpAll(
    () => registerFallbackValue(
      const FindItinerariesParams(from: from, to: to, preferences: prefs),
    ),
  );
  setUp(() => find = MockFind());

  test('succès : renvoie les itinéraires', () async {
    const list = [Itinerary(label: ItineraryLabel.eco, steps: [])];
    when(
      () => find(any()),
    ).thenAnswer((_) async => const Right<Failure, List<Itinerary>>(list));
    final cubit = ItineraryCubit(find, minLoading: Duration.zero);

    await cubit.search(from: from, to: to, preferences: prefs);

    expect(cubit.state.status, LoadStatus.success);
    expect(cubit.state.data, list);
    await cubit.close();
  });

  test('aucun itinéraire : succès avec une liste vide', () async {
    when(
      () => find(any()),
    ).thenAnswer((_) async => const Right<Failure, List<Itinerary>>([]));
    final cubit = ItineraryCubit(find, minLoading: Duration.zero);

    await cubit.search(from: from, to: to, preferences: prefs);

    expect(cubit.state.status, LoadStatus.success);
    expect(cubit.state.data, isEmpty);
    await cubit.close();
  });

  test('échec : garde le message de l’erreur', () async {
    when(() => find(any())).thenAnswer(
      (_) async => const Left<Failure, List<Itinerary>>(LocalFailure('boum')),
    );
    final cubit = ItineraryCubit(find, minLoading: Duration.zero);

    await cubit.search(from: from, to: to, preferences: prefs);

    expect(cubit.state.status, LoadStatus.failure);
    expect(cubit.state.message, 'boum');
    await cubit.close();
  });

  test('fermer l’écran pendant le calcul ne plante pas', () async {
    when(() => find(any())).thenAnswer((_) async {
      await Future<void>.delayed(const Duration(milliseconds: 20));
      return const Right<Failure, List<Itinerary>>([]);
    });
    final cubit = ItineraryCubit(find, minLoading: Duration.zero);

    final running = cubit.search(from: from, to: to, preferences: prefs);
    await cubit.close();
    await running;
  });
}
