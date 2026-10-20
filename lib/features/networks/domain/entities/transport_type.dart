import 'package:equatable/equatable.dart';
import 'package:yoon_wi/core/constants/transport_mode.dart';
import 'package:yoon_wi/features/networks/domain/entities/line.dart';

class TransportType extends Equatable {
  const TransportType({
    required this.name,
    required this.mode,
    required this.lines,
  });

  final String name;
  final TransportMode mode;
  final List<Line> lines;

  int get minFare =>
      lines.isEmpty
          ? 0
          : lines.map((l) => l.fare).reduce((a, b) => a < b ? a : b);

  @override
  List<Object> get props => [name, mode, lines];
}
