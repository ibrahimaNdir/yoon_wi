import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yoon_wi/core/error/failures.dart';
import 'package:yoon_wi/features/search/domain/entities/place.dart';
import 'package:yoon_wi/features/search/domain/repositories/place_repository.dart';
import 'package:yoon_wi/features/search/domain/usecases/search_places.dart';

class FakePlaceRepository implements PlaceRepository {
  @override
  Future<Either<Failure, List<Place>>> getPlaces() async => const Right([
    Place(
      id: 'ucad',
      name: 'UCAD',
      zone: 'Fann',
      isPopular: true,
      aliases: ['université'],
    ),
    Place(
      id: 'petersen',
      name: 'Petersen',
      zone: 'Centre-ville',
      isPopular: true,
    ),
    Place(id: 'liberte-6', name: 'Liberté 6', zone: 'Liberté', isPopular: true),
    Place(id: 'pikine', name: 'Pikine', zone: 'Banlieue', isPopular: false),
  ]);
}

void main() {
  final search = SearchPlaces(FakePlaceRepository());

  List<String> names(Either<Failure, List<Place>> r) =>
      r.fold((_) => [], (list) => list.map((p) => p.name).toList());

  test('requête vide : seulement les lieux populaires', () async {
    expect(names(await search('')), ['UCAD', 'Petersen', 'Liberté 6']);
  });

  test('trouve sans tenir compte des accents', () async {
    expect(names(await search('liberte')), ['Liberté 6']);
  });

  test('trouve par alias', () async {
    expect(names(await search('univers')), ['UCAD']);
  });

  test('le début du nom passe avant le reste', () async {
    expect(names(await search('pi')).first, 'Pikine');
  });

  test('aucun résultat pour un lieu inconnu', () async {
    expect(names(await search('zzz')), isEmpty);
  });
}
