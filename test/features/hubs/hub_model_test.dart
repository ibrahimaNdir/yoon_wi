import 'package:flutter_test/flutter_test.dart';
import 'package:yoon_wi/core/constants/transport_mode.dart';
import 'package:yoon_wi/core/error/exceptions.dart';
import 'package:yoon_wi/features/hubs/data/models/hub_model.dart';

void main() {
  test('lit un hub avec ses correspondances', () {
    final hub = HubModel.fromJson({
      'id': 'colobane',
      'nom': 'Colobane',
      'reseaux': ['Bus Tata', 'BRT'],
      'correspondances': [
        {'de': 'Bus Tata', 'vers': 'BRT', 'marche_min': 4},
      ],
    });

    expect(hub.name, 'Colobane');
    expect(hub.networks, [TransportMode.tata, TransportMode.brt]);
    expect(hub.transfers.single.walkMinutes, 4);
  });

  test('un réseau inconnu est refusé', () {
    expect(
      () => HubModel.fromJson({
        'id': 'x',
        'nom': 'X',
        'reseaux': ['Métro'],
        'correspondances': <Map<String, dynamic>>[],
      }),
      throwsA(isA<LocalException>()),
    );
  });
}
