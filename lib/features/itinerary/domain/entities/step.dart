import 'package:equatable/equatable.dart';
import 'package:yoon_wi/core/constants/transport_mode.dart';

enum StepKind { walkStart, ride, transfer, walkEnd }

class ItineraryStep extends Equatable {
  const ItineraryStep({
    required this.kind,
    required this.from,
    required this.to,
    required this.minMinutes,
    required this.maxMinutes,
    this.mode,
    this.lineName,
    this.lineCode,
    this.stopsCount = 0,
    this.waitMinMinutes = 0,
    this.waitMaxMinutes = 0,
    this.fare = 0,
  });

  final StepKind kind;
  final String from;
  final String to;

  /// Durée de l'étape elle-même (marche ou trajet), sans l'attente.
  final int minMinutes;
  final int maxMinutes;

  final TransportMode? mode;
  final String? lineName;

  /// Code de la ligne dans les données (sert à ouvrir sa page).
  final String? lineCode;
  final int stopsCount;

  /// Attente avant de monter (étapes de type trajet seulement).
  final int waitMinMinutes;
  final int waitMaxMinutes;

  /// Ticket payé à la montée (étapes de type trajet seulement).
  final int fare;

  int get totalMin => minMinutes + waitMinMinutes;
  int get totalMax => maxMinutes + waitMaxMinutes;

  @override
  List<Object?> get props => [
    kind,
    from,
    to,
    minMinutes,
    maxMinutes,
    mode,
    lineName,
    lineCode,
    stopsCount,
    waitMinMinutes,
    waitMaxMinutes,
    fare,
  ];
}
