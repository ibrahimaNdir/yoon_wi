import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yoon_wi/features/favorites/data/datasources/favorites_local_datasource.dart';
import 'package:yoon_wi/features/favorites/data/repositories/favorites_repository_impl.dart';
import 'package:yoon_wi/features/favorites/domain/entities/favorites.dart';
import 'package:yoon_wi/features/search/domain/entities/place.dart';

void main() {
  const a = Place(
    id: 'a',
    name: 'A',
    zone: 'z',
    isPopular: true,
    aliases: ['alpha'],
  );
  const b = Place(id: 'b', name: 'B', zone: 'z', isPopular: false);

  late FavoritesRepositoryImpl repository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    repository = FavoritesRepositoryImpl(FavoritesLocalDataSourceImpl(prefs));
  });

  Favorites unwrap(dynamic either) =>
      (either as dynamic).getOrElse(() => Favorites.empty) as Favorites;

  test('au départ, rien n’est enregistré', () async {
    final result = unwrap(await repository.getFavorites());
    expect(result.places, isEmpty);
    expect(result.trips, isEmpty);
  });

  test('un lieu favori est conservé avec ses alias', () async {
    await repository.addPlace('Maison', a);
    final result = unwrap(await repository.getFavorites());
    expect(result.places.single.label, 'Maison');
    expect(result.places.single.place, a);
  });

  test('ajouter le même type remplace le lieu', () async {
    await repository.addPlace('Maison', a);
    final result = unwrap(await repository.addPlace('Maison', b));
    expect(result.places.length, 1);
    expect(result.places.single.place, b);
  });

  test('un trajet n’est enregistré qu’une fois', () async {
    await repository.saveTrip(a, b);
    final result = unwrap(await repository.saveTrip(a, b));
    expect(result.trips.length, 1);
    expect(result.isTripSaved('a', 'b'), isTrue);
    expect(result.isTripSaved('b', 'a'), isFalse);
  });

  test('on peut retirer un lieu et un trajet', () async {
    await repository.addPlace('Maison', a);
    await repository.saveTrip(a, b);
    await repository.removePlace('Maison');
    final result = unwrap(await repository.removeTrip('a>b'));
    expect(result.places, isEmpty);
    expect(result.trips, isEmpty);
  });
}
