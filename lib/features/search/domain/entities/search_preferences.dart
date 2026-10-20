import 'package:equatable/equatable.dart';
import 'package:yoon_wi/core/constants/transport_mode.dart';

enum RoutePriority { eco, express, fewerTransfers }

class SearchPreferences extends Equatable {
  const SearchPreferences({
    this.priority = RoutePriority.eco,
    this.modes = const {
      TransportMode.ter,
      TransportMode.brt,
      TransportMode.tata,
      TransportMode.ddd,
    },
    this.maxWalkMinutes = 10,
  });

  final RoutePriority priority;
  final Set<TransportMode> modes;
  final int maxWalkMinutes;

  SearchPreferences copyWith({
    RoutePriority? priority,
    Set<TransportMode>? modes,
    int? maxWalkMinutes,
  }) {
    return SearchPreferences(
      priority: priority ?? this.priority,
      modes: modes ?? this.modes,
      maxWalkMinutes: maxWalkMinutes ?? this.maxWalkMinutes,
    );
  }

  @override
  List<Object> get props => [priority, modes, maxWalkMinutes];
}
