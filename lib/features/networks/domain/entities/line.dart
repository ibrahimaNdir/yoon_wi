import 'package:equatable/equatable.dart';
import 'package:yoon_wi/features/networks/domain/entities/stop.dart';

class Line extends Equatable {
  const Line({
    required this.code,
    required this.name,
    required this.fare,
    required this.stops,
  });

  final String code;
  final String name;
  final int fare;
  final List<Stop> stops;

  @override
  List<Object> get props => [code, name, fare, stops];
}
