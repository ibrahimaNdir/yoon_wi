import 'package:flutter_test/flutter_test.dart';
import 'package:yoon_wi/core/constants/transport_mode.dart';
import 'package:yoon_wi/features/itinerary/domain/entities/itinerary.dart';
import 'package:yoon_wi/features/itinerary/domain/entities/step.dart';
import 'package:yoon_wi/features/itinerary/domain/share_text_builder.dart';
import 'package:yoon_wi/features/search/domain/entities/place.dart';

void main() {
  const from = Place(
    id: 'p',
    name: 'Parcelles Assainies',
    zone: 'z',
    isPopular: true,
  );
  const to = Place(id: 's', name: 'Sandaga', zone: 'z', isPopular: true);

  const itinerary = Itinerary(
    label: ItineraryLabel.eco,
    steps: [
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
    ],
  );

  test('le texte partagé résume le trajet', () {
    final text = ShareTextBuilder.build(
      itinerary: itinerary,
      from: from,
      to: to,
    );
    expect(
      text,
      'Yoon Wi · Parcelles Assainies → Sandaga\n'
      'Bus Tata Ligne 24 jusqu’à Colobane, puis Dakar Dem Dikk Ligne 10 jusqu’à Sandaga\n'
      '300\u00A0FCFA · 42 min à 1 h 07',
    );
  });
}
