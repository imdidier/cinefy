import 'package:intl/intl.dart';

class HumanFormat {
  static String number(double number) {
    final formattedNumber = NumberFormat.compactCurrency(
      decimalDigits: 2,
      symbol: '',
      locale: 'en',
    ).format(number);
    return formattedNumber;
  }
}
