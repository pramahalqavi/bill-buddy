import 'package:billbuddy/base/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/number_input_formatter.dart';

OutlineInputBorder outlineInputBorder(BuildContext context) {
  return OutlineInputBorder(
    borderSide: BorderSide(color: colorScheme(context).outline, width: 1),
  );
}

InputDecoration inputDecoration(BuildContext context, {double padding = 0, Widget? label, Widget? suffix}) {
  return InputDecoration(
      label: label,
      border: outlineInputBorder(context),
      contentPadding: EdgeInsets.all(padding),
      suffix: suffix);
}

TextEditingController textEditingControllerWithValue(String text) {
  return TextEditingController.fromValue(
      TextEditingValue(text: text));
}

List<TextInputFormatter> numberInputFormatters() {
  return [
    FilteringTextInputFormatter.digitsOnly,
    NumberInputFormatter()
  ];
}