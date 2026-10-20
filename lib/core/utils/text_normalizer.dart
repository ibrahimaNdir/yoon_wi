/// Rend la recherche tolérante : "Liberté 6" == "liberte 6",
/// "Patte d’Oie" == "patte d'oie".
class TextNormalizer {
  TextNormalizer._();

  static const _map = {
    'à': 'a',
    'â': 'a',
    'ä': 'a',
    'ç': 'c',
    'é': 'e',
    'è': 'e',
    'ê': 'e',
    'ë': 'e',
    'î': 'i',
    'ï': 'i',
    'ô': 'o',
    'ö': 'o',
    'ù': 'u',
    'û': 'u',
    'ü': 'u',
    'ÿ': 'y',
    'œ': 'oe',
  };

  static String normalize(String input) {
    final buffer = StringBuffer();
    for (final rune in input.toLowerCase().trim().runes) {
      final char = String.fromCharCode(rune);
      if (char == '-' || char == '’' || char == "'") {
        buffer.write(' ');
      } else {
        buffer.write(_map[char] ?? char);
      }
    }
    return buffer.toString().replaceAll(RegExp(r'\s+'), ' ');
  }
}
