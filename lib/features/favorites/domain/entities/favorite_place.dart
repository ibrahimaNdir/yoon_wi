import 'package:equatable/equatable.dart';
import 'package:yoon_wi/features/search/domain/entities/place.dart';

class FavoritePlace extends Equatable {
  const FavoritePlace({required this.label, required this.place});

  /// "Maison", "Études", "Travail"…
  final String label;
  final Place place;

  @override
  List<Object> get props => [label, place];
}
