import 'package:equatable/equatable.dart';
import 'package:yoon_wi/features/itinerary/domain/entities/step.dart';

/// Où en est l'utilisateur dans son trajet (logique pure, sans Flutter).
class GuidanceProgress extends Equatable {
  GuidanceProgress({required this.steps, this.index = 0})
    : assert(steps.isNotEmpty, 'Un trajet a toujours des étapes'),
      assert(index >= 0 && index < steps.length);

  final List<ItineraryStep> steps;

  /// Étape en cours, en partant de 0.
  final int index;

  ItineraryStep get current => steps[index];
  ItineraryStep? get next => isLast ? null : steps[index + 1];

  bool get isFirst => index == 0;
  bool get isLast => index == steps.length - 1;

  /// De 0 à 1, pour la barre de progression.
  double get fraction => (index + 1) / steps.length;

  /// Temps restant, étape en cours comprise.
  int get remainingMin =>
      steps.skip(index).fold(0, (sum, s) => sum + s.totalMin);
  int get remainingMax =>
      steps.skip(index).fold(0, (sum, s) => sum + s.totalMax);

  /// Tickets des étapes pas encore commencées.
  int get remainingFare =>
      steps.skip(index + 1).fold(0, (sum, s) => sum + s.fare);

  GuidanceProgress advance() =>
      isLast ? this : GuidanceProgress(steps: steps, index: index + 1);

  GuidanceProgress back() =>
      isFirst ? this : GuidanceProgress(steps: steps, index: index - 1);

  @override
  List<Object> get props => [steps, index];
}
