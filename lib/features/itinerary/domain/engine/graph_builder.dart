import 'package:yoon_wi/core/constants/transport_mode.dart';
import 'package:yoon_wi/core/utils/text_normalizer.dart';
import 'package:yoon_wi/features/hubs/domain/entities/hub.dart';
import 'package:yoon_wi/features/networks/domain/entities/line.dart';
import 'package:yoon_wi/features/networks/domain/entities/transport_type.dart';
import 'package:yoon_wi/features/search/domain/entities/search_preferences.dart';

enum EdgeKind { access, hop, transfer, egress }

/// Un déplacement entre deux points du graphe, avec ce qu'il coûte.
class GraphEdge {
  const GraphEdge({
    required this.to,
    required this.kind,
    this.walk = 0,
    this.waitMin = 0,
    this.waitMax = 0,
    this.rideMin = 0,
    this.rideMax = 0,
    this.fare = 0,
  });

  final int to;
  final EdgeKind kind;
  final int walk;
  final int waitMin;
  final int waitMax;
  final int rideMin;
  final int rideMax;
  final int fare;

  double get avgMinutes =>
      walk + (waitMin + waitMax) / 2 + (rideMin + rideMax) / 2;

  int get transfers => kind == EdgeKind.transfer ? 1 : 0;
}

/// Un arrêt sur une ligne précise (le même nom sur deux lignes = deux points).
class StopNode {
  const StopNode({
    required this.index,
    required this.type,
    required this.line,
    required this.stopIndex,
  });

  final int index;
  final TransportType type;
  final Line line;
  final int stopIndex;

  String get stopName => line.stops[stopIndex].name;
  String get normalizedName => TextNormalizer.normalize(stopName);
  TransportMode get mode => type.mode;

  bool sameLineAs(StopNode other) =>
      type.name == other.type.name && line.code == other.line.code;
}

class TransitGraph {
  const TransitGraph(this.nodes, this.adjacency);

  final List<StopNode> nodes;
  final List<List<GraphEdge>> adjacency;
}

class GraphBuilder {
  /// Marche entre deux réseaux d'un hub quand `hubs.json` ne la précise pas.
  static const defaultTransferWalk = 3;

  /// Marche entre deux lignes du même réseau.
  static const sameNetworkWalk = 2;

  TransitGraph build({
    required List<TransportType> types,
    required List<Hub> hubs,
    required SearchPreferences preferences,
  }) {
    final nodes = <StopNode>[];
    for (final type in types) {
      if (!preferences.modes.contains(type.mode)) continue;
      for (final line in type.lines) {
        for (var i = 0; i < line.stops.length; i++) {
          nodes.add(
            StopNode(index: nodes.length, type: type, line: line, stopIndex: i),
          );
        }
      }
    }

    final adjacency = List.generate(nodes.length, (_) => <GraphEdge>[]);

    // Trajet entre arrêts voisins d'une ligne, dans les deux sens.
    for (final node in nodes) {
      for (final delta in const [-1, 1]) {
        final next = node.stopIndex + delta;
        if (next < 0 || next >= node.line.stops.length) continue;
        adjacency[node.index].add(
          GraphEdge(
            to: node.index + delta,
            kind: EdgeKind.hop,
            rideMin: node.line.hopMin,
            rideMax: node.line.hopMax,
          ),
        );
      }
    }

    // Correspondances : seulement aux arrêts qui portent le nom d'un hub.
    final hubsByName = {
      for (final hub in hubs) TextNormalizer.normalize(hub.name): hub,
    };
    final groups = <String, List<StopNode>>{};
    for (final node in nodes) {
      if (hubsByName.containsKey(node.normalizedName)) {
        groups.putIfAbsent(node.normalizedName, () => []).add(node);
      }
    }
    for (final entry in groups.entries) {
      final hub = hubsByName[entry.key]!;
      for (final a in entry.value) {
        for (final b in entry.value) {
          if (a.sameLineAs(b)) continue;
          final walk = _walkMinutes(hub, a.mode, b.mode);
          if (walk > preferences.maxWalkMinutes) continue;
          adjacency[a.index].add(
            GraphEdge(
              to: b.index,
              kind: EdgeKind.transfer,
              walk: walk,
              waitMin: b.line.waitMin,
              waitMax: b.line.waitMax,
              fare: b.line.fare,
            ),
          );
        }
      }
    }

    return TransitGraph(nodes, adjacency);
  }

  int _walkMinutes(Hub hub, TransportMode a, TransportMode b) {
    if (a == b) return sameNetworkWalk;
    for (final t in hub.transfers) {
      if ((t.from == a && t.to == b) || (t.from == b && t.to == a)) {
        return t.walkMinutes;
      }
    }
    return defaultTransferWalk;
  }
}
