import 'package:flutter_test/flutter_test.dart';
import 'package:yoon_wi/features/history/presentation/history_labels.dart';

void main() {
  final now = DateTime(2026, 10, 20, 15, 30);

  test('classe un trajet selon son jour', () {
    expect(groupOf(DateTime(2026, 10, 20, 0, 5), now), HistoryGroup.today);
    expect(
      groupOf(DateTime(2026, 10, 19, 23, 50), now),
      HistoryGroup.yesterday,
    );
    expect(groupOf(DateTime(2026, 10, 16, 12), now), HistoryGroup.thisWeek);
    expect(groupOf(DateTime(2026, 10, 13, 12), now), HistoryGroup.older);
  });

  test('un trajet daté dans le futur est compté pour aujourd’hui', () {
    expect(groupOf(DateTime(2026, 10, 21, 8), now), HistoryGroup.today);
  });

  test('l’heure pour aujourd’hui, la date ensuite', () {
    expect(
      timeLabel(DateTime(2026, 10, 20, 7, 5), HistoryGroup.today),
      '07:05',
    );
    expect(
      timeLabel(DateTime(2026, 10, 13, 7, 5), HistoryGroup.older),
      '13/10',
    );
  });

  test('les libellés des groupes', () {
    expect(groupLabel(HistoryGroup.today), 'Aujourd’hui');
    expect(groupLabel(HistoryGroup.yesterday), 'Hier');
    expect(groupLabel(HistoryGroup.thisWeek), 'Cette semaine');
    expect(groupLabel(HistoryGroup.older), 'Plus ancien');
  });
}
