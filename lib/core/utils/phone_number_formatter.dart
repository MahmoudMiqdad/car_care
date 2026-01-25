class PhoneNumberFormatter {
  static String format(String phone) {
    var clean = phone.replaceAll(RegExp(r'\s+'), '');

    if (clean.endsWith('+')) {
      clean = '+${clean.substring(0, clean.length - 1)}';
    }

    if (!clean.startsWith('+')) {
      clean = '+$clean';
    }

    return clean;
  }
}
