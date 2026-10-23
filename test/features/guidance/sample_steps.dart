import 'package:yoon_wi/core/constants/transport_mode.dart';
import 'package:yoon_wi/features/itinerary/domain/entities/itinerary.dart';
import 'package:yoon_wi/features/itinerary/domain/entities/step.dart';

const sampleSteps = [
  ItineraryStep(
    kind: StepKind.walkStart,
    from: 'Parcelles Assainies',
    to: 'UCAD',
    minMinutes: 3,
    maxMinutes: 3,
  ),
  ItineraryStep(
    kind: StepKind.ride,
    mode: TransportMode.tata,
    lineName: 'Ligne 24',
    lineCode: 'Ligne 24',
    from: 'UCAD',
    to: 'Colobane',
    stopsCount: 2,
    minMinutes: 6,
    maxMinutes: 10,
    waitMinMinutes: 5,
    waitMaxMinutes: 12,
    fare: 150,
  ),
  ItineraryStep(
    kind: StepKind.transfer,
    from: 'Colobane',
    to: 'Colobane',
    minMinutes: 3,
    maxMinutes: 3,
  ),
  ItineraryStep(
    kind: StepKind.ride,
    mode: TransportMode.ddd,
    lineName: 'Ligne 10',
    lineCode: 'Ligne 10',
    from: 'Colobane',
    to: 'Sandaga',
    stopsCount: 4,
    minMinutes: 12,
    maxMinutes: 16,
    waitMinMinutes: 10,
    waitMaxMinutes: 20,
    fare: 150,
  ),
  ItineraryStep(
    kind: StepKind.walkEnd,
    from: 'Sandaga',
    to: 'Sandaga',
    minMinutes: 3,
    maxMinutes: 3,
  ),
];

const sampleItinerary = Itinerary(
  label: ItineraryLabel.eco,
  steps: sampleSteps,
);
