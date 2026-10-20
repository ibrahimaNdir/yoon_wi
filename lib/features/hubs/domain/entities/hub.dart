import 'package:equatable/equatable.dart';
import 'package:yoon_wi/core/constants/transport_mode.dart';

class Transfer extends Equatable {
  const Transfer({
    required this.from,
    required this.to,
    required this.walkMinutes,
  });

  final TransportMode from;
  final TransportMode to;
  final int walkMinutes;

  @override
  List<Object> get props => [from, to, walkMinutes];
}

class Hub extends Equatable {
  const Hub({
    required this.id,
    required this.name,
    required this.networks,
    required this.transfers,
  });

  final String id;
  final String name;
  final List<TransportMode> networks;
  final List<Transfer> transfers;

  @override
  List<Object> get props => [id, name, networks, transfers];
}
