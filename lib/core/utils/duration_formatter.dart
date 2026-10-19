class DurationFormatter {
  DurationFormatter._();

  static String minutes(int total) {
    if (total < 60) return '$total min';
    final h = total ~/ 60;
    final m = total % 60;
    return m == 0 ? '$h h' : '$h h ${m.toString().padLeft(2, '0')}';
  }

  /// range(35, 45) -> "35 à 45 min"
  static String range(int min, int max) {
    if (min == max) return minutes(min);
    if (max < 60) return '$min à $max min';
    return '${minutes(min)} à ${minutes(max)}';
  }
}
