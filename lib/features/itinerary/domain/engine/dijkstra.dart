import 'package:yoon_wi/features/itinerary/domain/engine/graph_builder.dart';

class PathResult {
  const PathResult(this.nodes, this.edges, this.cost);

  /// Indices des arrêts parcourus, dans l'ordre.
  final List<int> nodes;

  /// Tous les déplacements : accès, trajets, correspondances, sortie.
  /// Il y en a toujours `nodes.length + 1`.
  final List<GraphEdge> edges;
  final double cost;
}

class Dijkstra {
  Dijkstra._();

  /// Plus court chemin selon `cost`. Deux points virtuels sont ajoutés :
  /// le départ (index `nodeCount`) et l'arrivée (index `nodeCount + 1`).
  /// Le graphe est petit, donc on cherche le prochain point par balayage.
  static PathResult? shortestPath({
    required int nodeCount,
    required List<List<GraphEdge>> adjacency,
    required Map<int, GraphEdge> startEdges,
    required Map<int, GraphEdge> endEdges,
    required double Function(GraphEdge edge) cost,
  }) {
    final source = nodeCount;
    final target = nodeCount + 1;
    final total = nodeCount + 2;

    final dist = List<double>.filled(total, double.infinity);
    final prevNode = List<int>.filled(total, -1);
    final prevEdge = List<GraphEdge?>.filled(total, null);
    final done = List<bool>.filled(total, false);
    dist[source] = 0;

    for (var step = 0; step < total; step++) {
      var u = -1;
      var best = double.infinity;
      for (var i = 0; i < total; i++) {
        if (!done[i] && dist[i] < best) {
          best = dist[i];
          u = i;
        }
      }
      if (u == -1 || u == target) break;
      done[u] = true;

      final end = endEdges[u];
      final edges =
          u == source
              ? startEdges.values.toList()
              : [...adjacency[u], if (end != null) end];

      for (final edge in edges) {
        final candidate = dist[u] + cost(edge);
        if (candidate < dist[edge.to]) {
          dist[edge.to] = candidate;
          prevNode[edge.to] = u;
          prevEdge[edge.to] = edge;
        }
      }
    }

    if (dist[target] == double.infinity) return null;

    final edges = <GraphEdge>[];
    final nodes = <int>[];
    var current = target;
    while (current != source) {
      edges.add(prevEdge[current]!);
      current = prevNode[current];
      if (current != source) nodes.add(current);
    }
    return PathResult(
      nodes.reversed.toList(),
      edges.reversed.toList(),
      dist[target],
    );
  }
}
