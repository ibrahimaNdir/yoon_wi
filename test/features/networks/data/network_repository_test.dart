import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yoon_wi/core/error/exceptions.dart';
import 'package:yoon_wi/features/networks/data/datasources/network_local_datasource.dart';
import 'package:yoon_wi/features/networks/data/models/transport_type_model.dart';
import 'package:yoon_wi/features/networks/data/repositories/network_repository_impl.dart';

class MockLocal extends Mock implements NetworkLocalDataSource {}

void main() {
  late MockLocal local;
  late NetworkRepositoryImpl repository;

  final ddd = {
    'type': 'Dakar Dem Dikk',
    'lignes': [
      {
        'code': 'Ligne 10',
        'nom': 'Ligne 10',
        'tarif': 150,
        'arrets': ['A', 'B', 'C'],
      },
    ],
  };

  setUp(() {
    local = MockLocal();
    repository = NetworkRepositoryImpl(local);
    when(
      () => local.getNetworks(),
    ).thenAnswer((_) async => [TransportTypeModel.fromJson(ddd)]);
  });

  test('renvoie les arrêts de la ligne demandée', () async {
    final result = await repository.getLine('Dakar Dem Dikk', 'Ligne 10');
    expect(result.isRight(), isTrue);
    result.fold(
      (failure) => fail('échec inattendu'),
      (line) => expect(line.stops.map((s) => s.name), ['A', 'B', 'C']),
    );
  });

  test('une ligne inconnue donne un échec', () async {
    final result = await repository.getLine('Dakar Dem Dikk', 'Ligne 99');
    expect(result.isLeft(), isTrue);
  });

  test('un type inconnu donne un échec', () async {
    final result = await repository.getTransportType('Métro');
    expect(result.isLeft(), isTrue);
  });

  test('un type de transport inconnu dans le JSON est refusé', () {
    expect(
      () => TransportTypeModel.fromJson({'type': 'Métro', 'lignes': []}),
      throwsA(isA<LocalException>()),
    );
  });
}
