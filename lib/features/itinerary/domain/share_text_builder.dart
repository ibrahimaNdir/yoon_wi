import 'package:yoon_wi/core/utils/duration_formatter.dart';
import 'package:yoon_wi/core/utils/price_formatter.dart';
import 'package:yoon_wi/features/itinerary/domain/entities/itinerary.dart';
import 'package:yoon_wi/features/search/domain/entities/place.dart';

class ShareTextBuilder {
  ShareTextBuilder._();

  static String build({
    required Itinerary itinerary,
    required Place from,
    required Place to,
  }) {
    final rides = itinerary.rides
        .map((r) => '${r.mode!.label} ${r.lineName} jusqu’à ${r.to}')
        .join(', puis ');
    final price = PriceFormatter.format(itinerary.fare);
    final duration = DurationFormatter.range(
      itinerary.minMinutes,
      itinerary.maxMinutes,
    );
    return 'Yoon Wi · ${from.name} → ${to.name}\n$rides\n$price · $duration';
  }
}
