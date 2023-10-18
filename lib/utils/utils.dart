
import 'package:intl/intl.dart';

String digitOnly(String str) {
  return str.replaceAll(RegExp("[^0-9\-]"), "");
}

String digitAndDotOnly(String str) {
  return str.replaceAll(RegExp("[^0-9\-\.]"), "");
}

int stringToInt(String? str) {
  if (str == null) return 0;
  try {
    return int.parse(digitOnly(str));
  } catch (e) {
    return 0;
  }
}

double stringToDouble(String? str) {
  if (str == null) return 0;
  try {
    return double.parse(digitAndDotOnly(str));
  } catch (e) {
    return 0;
  }
}

String formatThousands(String str, {bool addNegativePrefix = false}) {
  try {
    NumberFormat formatter = NumberFormat.decimalPattern("en_US");
    int num = stringToInt(str);
    if (addNegativePrefix) num *= -1;
    return formatter.format(num);
  } catch (e) {
    return str;
  }
}

String formatThousandsDouble(double num, {bool addNegativePrefix = false}) {
  try {
    if (num % 1 == 0) {
      return formatThousands(num.toStringAsFixed(0), addNegativePrefix: addNegativePrefix);
    }
    double rounded = stringToDouble(num.toStringAsFixed(2));
    if (addNegativePrefix) rounded *= -1;
    NumberFormat formatter = NumberFormat.decimalPatternDigits(locale: "en_US", decimalDigits: 2);
    return formatter.format(rounded);
  } catch (e) {
    return "";
  }
}

String dateToString(DateTime date, {String format = "dd-MM-yyyy"}) {
  return DateFormat(format).format(date);
}

DateTime? stringToDate(String? formattedDate, {String format = "dd-MM-yyyy"}) {
  if (formattedDate == null) return null;
  try {
    return DateFormat(format).parse(formattedDate);
  } catch (error) {
    return null;
  }
}