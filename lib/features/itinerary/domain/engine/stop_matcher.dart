import 'package:yoon_wi/core/utils/text_normalizer.dart';
import 'package:yoon_wi/features/itinerary/domain/engine/graph_builder.dart';
import 'package:yoon_wi/features/search/domain/entities/place.dart';

class StopMatcher {
  StopMatcher._();

  /// Les arrêts qui portent le nom du lieu ou l'un de ses alias.
  static List<StopNode> candidates(Place place, List<StopNode> nodes) {
    final names = {
      TextNormalizer.normalize(place.name),
      ...place.aliases.map(TextNormalizer.normalize),
    };
    return nodes.where((n) => names.contains(n.normalizedName)).toList();
  }
}
