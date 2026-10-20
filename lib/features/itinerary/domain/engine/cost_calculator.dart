import 'package:yoon_wi/features/itinerary/domain/engine/graph_builder.dart';
import 'package:yoon_wi/features/search/domain/entities/search_preferences.dart';

class CostWeights {
  const CostWeights({
    required this.fare,
    required this.minutes,
    required this.transfer,
  });

  final double fare;
  final double minutes;
  final double transfer;
}

class CostCalculator {
  CostCalculator._();

  static CostWeights weightsFor(RoutePriority priority) {
    switch (priority) {
      // Le prix passe avant tout, la durée départage.
      case RoutePriority.eco:
        return const CostWeights(fare: 100, minutes: 1, transfer: 0);
      // La durée passe avant tout ; chaque correspondance coûte
      // l'équivalent de 1,5 minute de plus (risque de rater la suivante).
      case RoutePriority.express:
        return const CostWeights(fare: 0.1, minutes: 20, transfer: 30);
      // Le nombre de correspondances passe avant tout.
      case RoutePriority.fewerTransfers:
        return const CostWeights(fare: 0.1, minutes: 1, transfer: 1000);
    }
  }

  static double edgeCost(GraphEdge edge, CostWeights w) =>
      w.fare * edge.fare +
      w.minutes * edge.avgMinutes +
      w.transfer * edge.transfers;
}
