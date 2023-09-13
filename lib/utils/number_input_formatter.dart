import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class NumberInputFormatter extends TextInputFormatter {
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return TextEditingValue(
          text: "0", selection: TextSelection.collapsed(offset: 1));
    }
    String numOnly = newValue.text.replaceAll(RegExp("[.]|[,]|\D"), "");
    NumberFormat formatter = NumberFormat.decimalPattern("en_US");
    String newText = formatter.format(int.parse(numOnly));
    return newValue.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length));
  }
}
