import 'package:billbuddy/utils/utils.dart';
import 'package:flutter/services.dart';

class NumberInputFormatter extends TextInputFormatter {
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return TextEditingValue(
          text: "0", selection: TextSelection.collapsed(offset: 1));
    } else if (oldValue.text == "0" && newValue.text.length == 2) {
      String newText = newValue.text.replaceFirst("0", "");
      return TextEditingValue(
          text: newText, selection: TextSelection.collapsed(offset: 1));
    }
    String newText = formatThousands(newValue.text);
    return newValue.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length));
  }
}
