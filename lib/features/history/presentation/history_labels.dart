enum HistoryGroup { today, yesterday, thisWeek, older }

HistoryGroup groupOf(DateTime at, DateTime now) {
  // En UTC pour qu'un changement d'heure ne fausse pas le nombre de jours.
  final day = DateTime.utc(at.year, at.month, at.day);
  final today = DateTime.utc(now.year, now.month, now.day);
  final days = today.difference(day).inDays;
  if (days <= 0) return HistoryGroup.today;
  if (days == 1) return HistoryGroup.yesterday;
  if (days < 7) return HistoryGroup.thisWeek;
  return HistoryGroup.older;
}

String groupLabel(HistoryGroup group) {
  switch (group) {
    case HistoryGroup.today:
      return 'Aujourd’hui';
    case HistoryGroup.yesterday:
      return 'Hier';
    case HistoryGroup.thisWeek:
      return 'Cette semaine';
    case HistoryGroup.older:
      return 'Plus ancien';
  }
}

String _two(int n) => n.toString().padLeft(2, '0');

/// L'heure pour aujourd'hui et hier, la date au-delà.
String timeLabel(DateTime at, HistoryGroup group) {
  if (group == HistoryGroup.today || group == HistoryGroup.yesterday) {
    return '${_two(at.hour)}:${_two(at.minute)}';
  }
  return '${_two(at.day)}/${_two(at.month)}';
}
