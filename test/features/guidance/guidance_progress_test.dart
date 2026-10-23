import 'package:flutter_test/flutter_test.dart';
import 'package:yoon_wi/features/guidance/domain/entities/guidance_progress.dart';

import 'sample_steps.dart';

void main() {
  test('au début, tout le trajet reste à faire', () {
    final p = GuidanceProgress(steps: sampleSteps);
    expect(p.index, 0);
    expect(p.isFirst, isTrue);
    expect(p.isLast, isFalse);
    expect(p.remainingMin, 42);
    expect(p.remainingMax, 67);
    expect(p.remainingFare, 300);
    expect(p.fraction, closeTo(0.2, 0.001));
  });

  test('après la première montée, il reste un seul ticket à payer', () {
    final p = GuidanceProgress(steps: sampleSteps).advance();
    expect(p.index, 1);
    expect(p.remainingMin, 39);
    expect(p.remainingMax, 64);
    expect(p.remainingFare, 150);
  });

  test('à la dernière étape, il ne reste que la marche', () {
    final p = GuidanceProgress(steps: sampleSteps, index: 4);
    expect(p.isLast, isTrue);
    expect(p.next, isNull);
    expect(p.remainingMin, 3);
    expect(p.remainingFare, 0);
    expect(p.fraction, 1.0);
  });

  test('on ne dépasse ni la première ni la dernière étape', () {
    final first = GuidanceProgress(steps: sampleSteps);
    expect(first.back().index, 0);

    final last = GuidanceProgress(steps: sampleSteps, index: 4);
    expect(last.advance().index, 4);
  });
}
