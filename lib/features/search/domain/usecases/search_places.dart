import 'package:dartz/dartz.dart';
import 'package:yoon_wi/core/error/failures.dart';
import 'package:yoon_wi/core/usecases/usecase.dart';
import 'package:yoon_wi/core/utils/text_normalizer.dart';
import 'package:yoon_wi/features/search/domain/entities/place.dart';
import 'package:yoon_wi/features/search/domain/repositories/place_repository.dart';

/// Requête vide : les lieux populaires. Sinon : les lieux qui correspondent,
/// les meilleurs en premier.
class SearchPlaces extends UseCase<List<Place>, String> {
  SearchPlaces(this._repository);
  final PlaceRepository _repository;

  @override
  Future<Either<Failure, List<Place>>> call(String query) async {
    final result = await _repository.getPlaces();
    return result.map((places) {
      final q = TextNormalizer.normalize(query);
      if (q.isEmpty) return places.where((p) => p.isPopular).toList();

      final scored = <MapEntry<Place, int>>[];
      for (final place in places) {
        final score = _score(place, q);
        if (score > 0) scored.add(MapEntry(place, score));
      }
      scored.sort((a, b) {
        final byScore = b.value.compareTo(a.value);
        return byScore != 0 ? byScore : a.key.name.compareTo(b.key.name);
      });
      return scored.map((e) => e.key).toList();
    });
  }

  int _score(Place place, String q) {
    final name = TextNormalizer.normalize(place.name);
    if (name.startsWith(q)) return 4;
    if (name.split(' ').any((word) => word.startsWith(q))) return 3;
    if (name.contains(q)) return 2;
    if (place.aliases.any((a) => TextNormalizer.normalize(a).contains(q))) {
      return 2;
    }
    if (TextNormalizer.normalize(place.zone).contains(q)) return 1;
    return 0;
  }
}
