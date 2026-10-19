class PriceFormatter {
  PriceFormatter._();

  /// 2600 -> "2 600 FCFA" (espaces insécables)
  static String format(int amount, {bool withCurrency = true}) {
    final digits = amount.abs().toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buffer.write('\u00A0');
      buffer.write(digits[i]);
    }
    final sign = amount < 0 ? '-' : '';
    return withCurrency ? '$sign$buffer\u00A0FCFA' : '$sign$buffer';
  }
}
