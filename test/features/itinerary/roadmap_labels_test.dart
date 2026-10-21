import 'package:flutter_test/flutter_test.dart';
import 'package:yoon_wi/core/constants/transport_mode.dart';
import 'package:yoon_wi/features/itinerary/domain/entities/step.dart';
import 'package:yoon_wi/features/itinerary/presentation/roadmap_labels.dart';

void main() {
  test('identifiant de hub à partir du nom', () {
    expect(hubSlug('Liberté 6'), 'liberte-6');
    expect(hubSlug('Colobane'), 'colobane');
  });

  test('une étape de trajet ouvre la ligne', () {
    final view = describeStep(
      const ItineraryStep(
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
    );
    expect(view.title, 'Monte dans le Bus Tata Ligne 24');
    expect(view.action, StepAction.line);
  });

  test('une correspondance ouvre le hub, la marche n’a pas d’action', () {
    final transfer = describeStep(
      const ItineraryStep(
        kind: StepKind.transfer,
        from: 'Colobane',
        to: 'Colobane',
        minMinutes: 3,
        maxMinutes: 3,
      ),
    );
    expect(transfer.action, StepAction.hub);

    final walk = describeStep(
      const ItineraryStep(
        kind: StepKind.walkEnd,
        from: 'Sandaga',
        to: 'Sandaga',
        minMinutes: 3,
        maxMinutes: 3,
      ),
    );
    expect(walk.action, isNull);
  });
}
