import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yoon_wi/features/history/data/datasources/history_local_datasource.dart';
import 'package:yoon_wi/features/history/data/repositories/history_repository_impl.dart';
import 'package:yoon_wi/features/history/domain/entities/trip_history_entry.dart';
import 'package:yoon_wi/features/search/domain/entities/place.dart';

void main() {
  const a = Place(
      id: 'a', name: 'A', zone: 'z', isPopular: true, aliases: ['alpha']);
  const b = Place(id: 'b', name: 'B', zone: 'z', isPopular: false);
  const c = Place(id: 'c', name: 'C', zone: 'z', isPopular: false);

  TripHistoryEntry entry(Place from, Place to, DateTime at, {int fare = 300}) =>
      TripHistoryEntry(
        from: from,
        to: to,
        fare: fare,
        minMinutes: 30,
        maxMinutes: 45,
        at: at,
      );

  late HistoryRepositoryImpl repository;

  Future<List<TripHistoryEntry>> history() async =>
      (await repository.getHistory())
          .getOrElse(() => <TripHistoryEntry>[]);

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    repository = HistoryRepositoryImpl(HistoryLocalDataSourceImpl(prefs));
  });

  test('au départ, l’historique est vide', () async {
    expect(await history(), isEmpty);
  });

  test('le dernier trajet est en premier et les lieux sont conservés',
          () async {
        await repository.add(entry(a, b, DateTime(2026, 10, 1, 8)));
        await repository.add(entry(b, c, DateTime(2026, 10, 1, 9)));

        final result = await history();
        expect(result.map((e) => e.id), ['b>c', 'a>b']);
        expect(result.last.from.aliases, ['alpha']);
      });

  test('un trajet répété remonte en haut sans doublon', () async {
    await repository.add(entry(a, b, DateTime(2026, 10, 1, 8)));
    await repository.add(entry(b, c, DateTime(2026, 10, 1, 9)));
    await repository.add(entry(a, b, DateTime(2026, 10, 1, 10), fare: 450));

    final result = await history();
    expect(result.map((e) => e.id), ['a>b', 'b>c']);
    expect(result.first.fare, 450);
  });

  test('l’historique garde au maximum 50 trajets', () async {
    for (var i = 0; i < 55; i++) {
      final from = Place(
          id: 'p$i', name: 'P$i', zone: 'z', isPopular: false);
      await repository.add(entry(from, b, DateTime(2026, 10, 1, 8, i)));
    }
    final result = await history();
    expect(result.length, HistoryRepositoryImpl.maxEntries);
    expect(result.first.from.id, 'p54');
  });

  test('effacer vide l’historique', () async {
    await repository.add(entry(a, b, DateTime(2026, 10, 1, 8)));
    await repository.clear();
    expect(await history(), isEmpty);
  });

  test('des données illisibles donnent un historique vide', () async {
    SharedPreferences.setMockInitialValues({'history_v1': 'pas du json'});
    final prefs = await SharedPreferences.getInstance();
    repository = HistoryRepositoryImpl(HistoryLocalDataSourceImpl(prefs));
    expect(await history(), isEmpty);
  });
}