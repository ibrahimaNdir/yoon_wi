import 'package:flutter_test/flutter_test.dart';
import 'package:yoon_wi/core/constants/asset_paths.dart';
import 'package:yoon_wi/core/data/local_json_loader.dart';
import 'package:yoon_wi/core/error/exceptions.dart';
import 'package:yoon_wi/core/utils/json_parsers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final loader = LocalJsonLoader();

  test('reseaux.json respecte la hiérarchie type > lignes > arrêts', () async {
    final json = await loader.loadMap(AssetPaths.reseaux);
    final types = JsonParsers.objects(json, 'reseaux');

    expect(
      types.map((t) => t['type']),
      containsAll(['BRT', 'Bus Tata', 'Dakar Dem Dikk', 'TER']),
    );

    for (final type in types) {
      final lignes = JsonParsers.objects(type, 'lignes');
      expect(lignes, isNotEmpty, reason: '${type['type']} sans ligne');

      for (final ligne in lignes) {
        expect(JsonParsers.string(ligne, 'code'), isNotEmpty);
        expect(JsonParsers.integer(ligne, 'tarif'), greaterThan(0));
        expect(JsonParsers.strings(ligne, 'arrets'), isNotEmpty);
      }
    }
  });

  test('hubs.json contient les hubs du cahier des charges', () async {
    final json = await loader.loadMap(AssetPaths.hubs);
    final hubs = JsonParsers.objects(json, 'hubs');
    expect(
      hubs.map((h) => h['nom']),
      containsAll(['Colobane', 'UCAD', 'Petersen', 'Liberté 6', 'Guédiawaye']),
    );
  });

  test('places.json contient des lieux populaires dont Sandaga', () async {
    final json = await loader.loadMap(AssetPaths.places);
    final lieux = JsonParsers.objects(json, 'lieux');
    expect(lieux.map((l) => l['nom']), contains('Sandaga'));
    expect(lieux.where((l) => l['populaire'] == true), isNotEmpty);
  });

  test('un fichier absent lève une LocalException', () {
    expect(
      loader.loadMap('assets/data/inconnu.json'),
      throwsA(isA<LocalException>()),
    );
  });

  test('un champ manquant lève une LocalException', () {
    expect(
      () => JsonParsers.string(<String, dynamic>{}, 'nom'),
      throwsA(isA<LocalException>()),
    );
  });
}
