import 'package:flutter_test/flutter_test.dart';
import 'package:yoon_wi/core/utils/text_normalizer.dart';

void main() {
  test('retire accents, tirets et apostrophes', () {
    expect(TextNormalizer.normalize('Liberté 6'), 'liberte 6');
    expect(TextNormalizer.normalize('Patte d’Oie'), 'patte d oie');
    expect(TextNormalizer.normalize("Patte d'Oie"), 'patte d oie');
    expect(TextNormalizer.normalize('  UCAD '), 'ucad');
  });
}
