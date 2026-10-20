import 'package:equatable/equatable.dart';

enum TimeMode { now, departAt, arriveBy }

class TripTime extends Equatable {
  const TripTime({
    this.mode = TimeMode.now,
    this.minutes = 0,
    this.tomorrow = false,
  });

  final TimeMode mode;

  /// Minutes depuis minuit (450 = 07:30).
  final int minutes;
  final bool tomorrow;

  String get clock {
    final h = (minutes ~/ 60).toString().padLeft(2, '0');
    final m = (minutes % 60).toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  List<Object> get props => [mode, minutes, tomorrow];
}
