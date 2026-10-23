import 'package:flutter_test/flutter_test.dart';
import 'package:yoon_wi/features/guidance/presentation/bloc/guidance_cubit.dart';
import 'package:yoon_wi/features/search/domain/entities/place.dart';

import 'sample_steps.dart';

void main() {
  const from = Place(
    id: 'p',
    name: 'Parcelles Assainies',
    zone: 'z',
    isPopular: true,
  );
  const to = Place(id: 's', name: 'Sandaga', zone: 'z', isPopular: true);

  late DateTime now;
  late GuidanceCubit cubit;

  setUp(() {
    now = DateTime(2026, 10, 20, 8);
    cubit = GuidanceCubit(
      itinerary: sampleItinerary,
      from: from,
      to: to,
      clock: () => now,
    );
  });

  tearDown(() => cubit.close());

  test('le guidage démarre à la première étape', () {
    expect(cubit.state.progress.index, 0);
    expect(cubit.state.finished, isFalse);
  });

  test('on avance puis on revient en arrière', () {
    cubit.next();
    cubit.next();
    expect(cubit.state.progress.index, 2);
    cubit.previous();
    expect(cubit.state.progress.index, 1);
  });

  test('terminer la dernière étape produit le résumé du trajet', () {
    for (var i = 0; i < 4; i++) {
      cubit.next();
    }
    expect(cubit.state.progress.isLast, isTrue);
    expect(cubit.state.finished, isFalse);

    now = now.add(const Duration(minutes: 41, seconds: 20));
    cubit.next();

    final summary = cubit.state.summary!;
    expect(summary.actualMinutes, 42);
    expect(summary.fare, 300);
    expect(summary.plannedMin, 42);
    expect(summary.plannedMax, 67);
    expect(summary.to.name, 'Sandaga');
  });

  test('un trajet terminé instantanément compte au moins 1 minute', () {
    for (var i = 0; i < 5; i++) {
      cubit.next();
    }
    expect(cubit.state.summary!.actualMinutes, 1);
  });

  test('une fois terminé, plus rien ne bouge', () {
    for (var i = 0; i < 5; i++) {
      cubit.next();
    }
    final summary = cubit.state.summary;
    cubit.next();
    cubit.previous();
    expect(cubit.state.summary, summary);
    expect(cubit.state.progress.index, 4);
  });
}
