import 'package:flutter_test/flutter_test.dart';
import 'package:yoon_wi/core/constants/transport_mode.dart';
import 'package:yoon_wi/features/hubs/domain/entities/hub.dart';
import 'package:yoon_wi/features/itinerary/domain/engine/route_planner.dart';
import 'package:yoon_wi/features/itinerary/domain/entities/itinerary.dart';
import 'package:yoon_wi/features/itinerary/domain/entities/step.dart';
import 'package:yoon_wi/features/networks/domain/entities/line.dart';
import 'package:yoon_wi/features/networks/domain/entities/stop.dart';
import 'package:yoon_wi/features/networks/domain/entities/transport_type.dart';
import 'package:yoon_wi/features/search/domain/entities/place.dart';
import 'package:yoon_wi/features/search/domain/entities/search_preferences.dart';

Line _line(
  String code,
  int fare,
  List<String> stops, {
  required int wait,
  required int waitMax,
  required int hop,
  required int hopMax,
}) => Line(
  code: code,
  name: code,
  fare: fare,
  stops: stops.map(Stop.new).toList(),
  waitMin: wait,
  waitMax: waitMax,
  hopMin: hop,
  hopMax: hopMax,
);

void main() {
  final types = [
    TransportType(
      name: 'BRT',
      mode: TransportMode.brt,
      lines: [
        _line(
          'B1',
          300,
          ['Guédiawaye', 'Arrêt B', 'Colobane', 'Petersen'],
          wait: 3,
          waitMax: 6,
          hop: 2,
          hopMax: 3,
        ),
      ],
    ),
    TransportType(
      name: 'Bus Tata',
      mode: TransportMode.tata,
      lines: [
        _line(
          'Ligne 24',
          150,
          ['UCAD', 'Fann', 'Colobane', 'HLM', 'Parcelles Assainies'],
          wait: 5,
          waitMax: 12,
          hop: 3,
          hopMax: 5,
        ),
      ],
    ),
    TransportType(
      name: 'Dakar Dem Dikk',
      mode: TransportMode.ddd,
      lines: [
        _line(
          'Ligne 10',
          150,
          ['Colobane', 'Arrêt A', 'Arrêt B', 'Arrêt C', 'Sandaga'],
          wait: 10,
          waitMax: 20,
          hop: 3,
          hopMax: 4,
        ),
        _line(
          'Ligne 15',
          150,
          ['Petersen', 'Sandaga'],
          wait: 6,
          waitMax: 12,
          hop: 3,
          hopMax: 4,
        ),
      ],
    ),
  ];

  final hubs = [
    Hub(
      id: 'colobane',
      name: 'Colobane',
      networks: const [
        TransportMode.tata,
        TransportMode.brt,
        TransportMode.ddd,
      ],
      transfers: const [
        Transfer(
          from: TransportMode.tata,
          to: TransportMode.brt,
          walkMinutes: 4,
        ),
        Transfer(
          from: TransportMode.brt,
          to: TransportMode.ddd,
          walkMinutes: 3,
        ),
        Transfer(
          from: TransportMode.tata,
          to: TransportMode.ddd,
          walkMinutes: 3,
        ),
      ],
    ),
    Hub(
      id: 'petersen',
      name: 'Petersen',
      networks: const [TransportMode.brt, TransportMode.ddd],
      transfers: const [
        Transfer(
          from: TransportMode.brt,
          to: TransportMode.ddd,
          walkMinutes: 2,
        ),
      ],
    ),
  ];

  const parcelles = Place(
    id: 'parcelles',
    name: 'Parcelles Assainies',
    zone: 'Parcelles',
    isPopular: true,
  );
  const sandaga = Place(
    id: 'sandaga',
    name: 'Sandaga',
    zone: 'Plateau',
    isPopular: true,
  );
  const pikine = Place(
    id: 'pikine',
    name: 'Pikine',
    zone: 'Banlieue',
    isPopular: false,
  );
  const colobane = Place(
    id: 'colobane',
    name: 'Gare de Colobane',
    zone: 'Colobane',
    isPopular: true,
    aliases: ['colobane'],
  );

  final planner = LocalRoutePlanner();

  List<Itinerary> plan(
    Place from,
    Place to, [
    SearchPreferences prefs = const SearchPreferences(),
  ]) => planner.plan(
    from: from,
    to: to,
    types: types,
    hubs: hubs,
    preferences: prefs,
  );

  double avg(Itinerary i) => (i.minMinutes + i.maxMinutes) / 2;

  test('Éco : le trajet le moins cher, avec une correspondance', () {
    final eco = plan(
      parcelles,
      sandaga,
    ).firstWhere((i) => i.label == ItineraryLabel.eco);

    expect(eco.fare, 300);
    expect(eco.transfers, 1);
    expect(eco.steps.map((s) => s.kind).toList(), [
      StepKind.walkStart,
      StepKind.ride,
      StepKind.transfer,
      StepKind.ride,
      StepKind.walkEnd,
    ]);
    expect(eco.modes, [TransportMode.tata, TransportMode.ddd]);
  });

  test('Express : plus cher mais plus rapide que l’Éco', () {
    final result = plan(parcelles, sandaga);
    final eco = result.firstWhere((i) => i.label == ItineraryLabel.eco);
    final express = result.firstWhere((i) => i.label == ItineraryLabel.express);

    expect(express.fare, 600);
    expect(express.transfers, 2);
    expect(avg(express), lessThan(avg(eco)));
  });

  test('la priorité choisie passe en premier', () {
    final result = plan(
      parcelles,
      sandaga,
      const SearchPreferences(priority: RoutePriority.express),
    );
    expect(result.first.label, ItineraryLabel.express);
  });

  test('un trajet direct n’a pas de correspondance', () {
    final result = plan(parcelles, colobane);
    expect(result.first.fare, 150);
    expect(result.first.transfers, 0);
    expect(result.first.steps.length, 3);
  });

  test('les doublons sont fusionnés', () {
    final result = plan(
      parcelles,
      sandaga,
      const SearchPreferences(modes: {TransportMode.tata, TransportMode.ddd}),
    );
    expect(result.length, 1);
    expect(result.single.modes, [TransportMode.tata, TransportMode.ddd]);
  });

  test('un lieu sans arrêt ne donne aucun itinéraire', () {
    expect(plan(parcelles, pikine), isEmpty);
  });

  test('le même lieu au départ et à l’arrivée ne donne rien', () {
    expect(plan(parcelles, parcelles), isEmpty);
  });

  test('sans les bons réseaux, aucun itinéraire', () {
    expect(
      plan(
        parcelles,
        sandaga,
        const SearchPreferences(modes: {TransportMode.tata}),
      ),
      isEmpty,
    );
  });

  test('une marche maximale trop courte bloque tout', () {
    expect(
      plan(parcelles, sandaga, const SearchPreferences(maxWalkMinutes: 2)),
      isEmpty,
    );
  });

  test('chaque trajet respecte la fourchette de durée', () {
    for (final itinerary in plan(parcelles, sandaga)) {
      expect(itinerary.minMinutes, lessThan(itinerary.maxMinutes));
      expect(itinerary.minMinutes, greaterThan(0));
    }
  });
}
