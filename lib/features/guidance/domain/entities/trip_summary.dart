import 'package:equatable/equatable.dart';
import 'package:yoon_wi/features/search/domain/entities/place.dart';

class TripSummary extends Equatable {
  const TripSummary({
    required this.from,
    required this.to,
    required this.fare,
    required this.plannedMin,
    required this.plannedMax,
    required this.actualMinutes,
  });

  final Place from;
  final Place to;
  final int fare;
  final int plannedMin;
  final int plannedMax;

  /// Durée entre le début du guidage et la dernière étape.
  final int actualMinutes;

  @override
  List<Object> get props => [
    from,
    to,
    fare,
    plannedMin,
    plannedMax,
    actualMinutes,
  ];
}
