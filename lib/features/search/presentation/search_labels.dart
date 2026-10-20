import 'package:yoon_wi/features/search/domain/entities/search_preferences.dart';
import 'package:yoon_wi/features/search/domain/entities/trip_time.dart';

String _day(TripTime t) => t.tomorrow ? 'demain ' : '';

String timeShortLabel(TripTime t) {
  switch (t.mode) {
    case TimeMode.now:
      return 'Maintenant';
    case TimeMode.departAt:
      return 'Partir ${_day(t)}${t.clock}';
    case TimeMode.arriveBy:
      return 'Arriver ${_day(t)}${t.clock}';
  }
}

String priorityShortLabel(RoutePriority p) {
  switch (p) {
    case RoutePriority.eco:
      return 'Éco';
    case RoutePriority.express:
      return 'Express';
    case RoutePriority.fewerTransfers:
      return 'Peu de changements';
  }
}

String priorityLongLabel(RoutePriority p) {
  switch (p) {
    case RoutePriority.eco:
      return 'Éco, le moins cher';
    case RoutePriority.express:
      return 'Express, le plus rapide';
    case RoutePriority.fewerTransfers:
      return 'Moins de correspondances';
  }
}
