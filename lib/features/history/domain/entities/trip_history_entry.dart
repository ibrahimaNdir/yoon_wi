import 'package:equatable/equatable.dart';
import 'package:yoon_wi/features/search/domain/entities/place.dart';

class TripHistoryEntry extends Equatable {
  const TripHistoryEntry({
    required this.from,
    required this.to,
    required this.fare,
    required this.minMinutes,
    required this.maxMinutes,
    required this.at,
  });

  final Place from;
  final Place to;
  final int fare;
  final int minMinutes;
  final int maxMinutes;
  final DateTime at;

  /// Même départ et même arrivée = même trajet.
  String get id => '${from.id}>${to.id}';

  @override
  List<Object> get props => [from, to, fare, minMinutes, maxMinutes, at];
}
