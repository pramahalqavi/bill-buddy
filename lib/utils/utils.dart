
import 'package:intl/intl.dart';

String digitOnly(String str) {
  return str.replaceAll(RegExp("[^0-9\-]"), "");
}

String digitAndDotOnly(String str) {
  return str.replaceAll(RegExp("[^0-9\-\.]"), "");
}

int stringToInt(String? str) {
  if (str == null) return 0;
  return int.parse(digitOnly(str));
}

double stringToDouble(String? str) {
  if (str == null) return 0;
  return double.parse(digitAndDotOnly(str));
}

String formatThousands(String str) {
  try {
    NumberFormat formatter = NumberFormat.decimalPattern("en_US");
    return formatter.format(stringToInt(str));
  } catch (e) {
    return str;
  }
}

String formatThousandsDouble(double num) {
  try {
    if (num % 1 == 0) {
      return formatThousands(num.toStringAsFixed(0));
    }
    double rounded = stringToDouble(num.toStringAsFixed(2));
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