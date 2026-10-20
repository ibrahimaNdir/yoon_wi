import 'package:yoon_wi/features/hubs/domain/entities/hub.dart';
import 'package:yoon_wi/features/itinerary/domain/engine/cost_calculator.dart';
import 'package:yoon_wi/features/itinerary/domain/engine/dijkstra.dart';
import 'package:yoon_wi/features/itinerary/domain/engine/graph_builder.dart';
import 'package:yoon_wi/features/itinerary/domain/engine/stop_matcher.dart';
import 'package:yoon_wi/features/itinerary/domain/entities/itinerary.dart';
import 'package:yoon_wi/features/itinerary/domain/entities/step.dart';
import 'package:yoon_wi/features/networks/domain/entities/transport_type.dart';
import 'package:yoon_wi/features/search/domain/entities/place.dart';
import 'package:yoon_wi/features/search/domain/entities/search_preferences.dart';

abstract class RoutePlanner {
  List<Itinerary> plan({
    required Place from,
    required Place to,
    required List<TransportType> types,
    required List<Hub> hubs,
    required SearchPreferences preferences,
  });
}

/// Calcule les trajets sur le téléphone, avec les données locales.
/// Plus tard, une autre implémentation pourra interroger le serveur.
class LocalRoutePlanner implements RoutePlanner {
  /// Marche entre un lieu et son arrêt le plus proche (valeur d'exemple).
  static const accessWalkMinutes = 3;

  @override
  List<Itinerary> plan({
    required Place from,
    required Place to,
    required List<TransportType> types,
    required List<Hub> hubs,
    required SearchPreferences preferences,
  }) {
    if (accessWalkMinutes > preferences.maxWalkMinutes) return const [];

    final graph = GraphBuilder().build(
      types: types,
      hubs: hubs,
      preferences: preferences,
    );
    final starts = StopMatcher.candidates(from, graph.nodes);
    final ends = StopMatcher.candidates(to, graph.nodes);
    if (starts.isEmpty || ends.isEmpty) return const [];

    // Départ et arrivée au même arrêt : il n'y a pas de trajet à proposer.
    final startNames = starts.map((n) => n.normalizedName).toSet();
    if (ends.any((n) => startNames.contains(n.normalizedName))) {
      return const [];
    }

    final target = graph.nodes.length + 1;
    final startEdges = {
      for (final n in starts)
        n.index: GraphEdge(
          to: n.index,
          kind: EdgeKind.access,
          walk: accessWalkMinutes,
          waitMin: n.line.waitMin,
          waitMax: n.line.waitMax,
          fare: n.line.fare,
        ),
    };
    final endEdges = {
      for (final n in ends)
        n.index: GraphEdge(
          to: target,
          kind: EdgeKind.egress,
          walk: accessWalkMinutes,
        ),
    };

    final order = [
      preferences.priority,
      ...RoutePriority.values.where((p) => p != preferences.priority),
    ];

    final results = <Itinerary>[];
    final seen = <String>{};
    for (final priority in order) {
      final weights = CostCalculator.weightsFor(priority);
      final path = Dijkstra.shortestPath(
        nodeCount: graph.nodes.length,
        adjacency: graph.adjacency,
        startEdges: startEdges,
        endEdges: endEdges,
        cost: (edge) => CostCalculator.edgeCost(edge, weights),
      );
      if (path == null) continue;

      final itinerary = _toItinerary(path, graph, from, to, _labelOf(priority));
      if (itinerary == null || !seen.add(itinerary.signature)) continue;
      results.add(itinerary);
    }
    return results;
  }

  ItineraryLabel _labelOf(RoutePriority priority) {
    switch (priority) {
      case RoutePriority.eco:
        return ItineraryLabel.eco;
      case RoutePriority.express:
        return ItineraryLabel.express;
      case RoutePriority.fewerTransfers:
        return ItineraryLabel.fewerTransfers;
    }
  }

  Itinerary? _toItinerary(
    PathResult path,
    TransitGraph graph,
    Place from,
    Place to,
    ItineraryLabel label,
  ) {
    final nodes = path.nodes.map((i) => graph.nodes[i]).toList();
    final steps = <ItineraryStep>[];

    final access = path.edges.first;
    steps.add(
      ItineraryStep(
        kind: StepKind.walkStart,
        from: from.name,
        to: nodes.first.stopName,
        minMinutes: access.walk,
        maxMinutes: access.walk,
      ),
    );

    var boarding = access;
    var rideStart = nodes.first;
    var hops = 0;
    var rideMin = 0;
    var rideMax = 0;

    ItineraryStep closeRide(StopNode end) => ItineraryStep(
      kind: StepKind.ride,
      mode: rideStart.mode,
      lineName: rideStart.line.name,
      from: rideStart.stopName,
      to: end.stopName,
      stopsCount: hops,
      minMinutes: rideMin,
      maxMinutes: rideMax,
      waitMinMinutes: boarding.waitMin,
      waitMaxMinutes: boarding.waitMax,
      fare: boarding.fare,
    );

    for (var i = 1; i < nodes.length; i++) {
      final edge = path.edges[i];
      if (edge.kind == EdgeKind.hop) {
        hops++;
        rideMin += edge.rideMin;
        rideMax += edge.rideMax;
      } else {
        steps.add(closeRide(nodes[i - 1]));
        steps.add(
          ItineraryStep(
            kind: StepKind.transfer,
            from: nodes[i - 1].stopName,
            to: nodes[i].stopName,
            minMinutes: edge.walk,
            maxMinutes: edge.walk,
          ),
        );
        boarding = edge;
        rideStart = nodes[i];
        hops = 0;
        rideMin = 0;
        rideMax = 0;
      }
    }
    steps.add(closeRide(nodes.last));

    final egress = path.edges.last;
    steps.add(
      ItineraryStep(
        kind: StepKind.walkEnd,
        from: nodes.last.stopName,
        to: to.name,
        minMinutes: egress.walk,
        maxMinutes: egress.walk,
      ),
    );

    final hasEmptyRide = steps.any(
      (s) => s.kind == StepKind.ride && s.stopsCount == 0,
    );
    if (hasEmptyRide) return null;
    return Itinerary(label: label, steps: steps);
  }
}
