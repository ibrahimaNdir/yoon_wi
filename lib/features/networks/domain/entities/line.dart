import 'package:equatable/equatable.dart';
import 'package:yoon_wi/features/networks/domain/entities/stop.dart';

class Line extends Equatable {
  const Line({
    required this.code,
    required this.name,
    required this.fare,
    required this.stops,
    required this.waitMin,
    required this.waitMax,
    required this.hopMin,
    required this.hopMax,
  });

  final String code;
  final String name;
  final int fare;
  final List<Stop> stops;

  /// Attente à l'arrêt avant de monter, en minutes.
  final int waitMin;
  final int waitMax;

  /// Durée entre deux arrêts consécutifs, en minutes.
  final int hopMin;
  final int hopMax;

  @override
  List<Object> get props => [
    code,
    name,
    fare,
    stops,
    waitMin,
    waitMax,
    hopMin,
    hopMax,
  ];
}
