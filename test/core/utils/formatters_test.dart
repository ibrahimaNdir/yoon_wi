import 'package:flutter_test/flutter_test.dart';
import 'package:yoon_wi/core/utils/duration_formatter.dart';
import 'package:yoon_wi/core/utils/price_formatter.dart';

void main() {
  test('formate un prix en FCFA', () {
    expect(PriceFormatter.format(2600), '2\u00A0600\u00A0FCFA');
    expect(PriceFormatter.format(150), '150\u00A0FCFA');
  });

  test('formate une durée', () {
    expect(DurationFormatter.range(35, 45), '35 à 45 min');
    expect(DurationFormatter.minutes(65), '1 h 05');
  });
}
