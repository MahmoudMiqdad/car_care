/// Eastern Arabic numerals (٠–٩) and helpers for RTL-friendly display.
class ArabicFormatting {
  ArabicFormatting._();

  static const String easternDigits = '٠١٢٣٤٥٦٧٨٩';

  /// Replaces Western digits 0–9 in [input] with Eastern Arabic digits.
  static String toEasternDigits(String input) {
    return input.replaceAllMapped(RegExp(r'\d'), (m) {
      final d = int.parse(m[0]!);
      return easternDigits[d];
    });
  }

  /// Formats [date] as `d/m/y` with Eastern Arabic numerals.
  static String formatDateSlashedEastern(DateTime date) {
    final raw = '${date.day}/${date.month}/${date.year}';
    return toEasternDigits(raw);
  }
}
