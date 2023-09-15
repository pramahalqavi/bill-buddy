
import 'package:intl/intl.dart';

String digitOnly(String str) {
  return str.replaceAll(RegExp("[^0-9\-]"), "");
}

int stringToInt(String? str) {
  if (str == null) return 0;
  return int.parse(digitOnly(str));
}

String formatThousands(String str) {
  NumberFormat formatter = NumberFormat.decimalPattern("en_US");
  return formatter.format(stringToInt(str));
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