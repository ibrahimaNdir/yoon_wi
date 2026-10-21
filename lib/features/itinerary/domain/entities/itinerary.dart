import 'package:equatable/equatable.dart';
import 'package:yoon_wi/core/constants/transport_mode.dart';
import 'package:yoon_wi/features/itinerary/domain/entities/step.dart';

enum ItineraryLabel { eco, express, fewerTransfers }

class Itinerary extends Equatable {
  const Itinerary({required this.label, required this.steps});

  final ItineraryLabel label;
  final List<ItineraryStep> steps;

  List<ItineraryStep> get rides =>
      steps.where((s) => s.kind == StepKind.ride).toList();

  List<TransportMode> get modes => rides.map((r) => r.mode!).toList();

  /// Prix total en FCFA : un ticket par montée.
  int get fare => steps.fold(0, (sum, s) => sum + s.fare);

  int get minMinutes => steps.fold(0, (sum, s) => sum + s.totalMin);
  int get maxMinutes => steps.fold(0, (sum, s) => sum + s.totalMax);

  int get transfers => steps.where((s) => s.kind == StepKind.transfer).length;

  /// Identifie le parcours, pour retirer les doublons.
  String get signature => rides
      .map((r) => '${r.mode?.label}|${r.lineName}|${r.from}>${r.to}')
      .join('/');

  @override
  List<Object> get props => [label, steps];
}
