import 'package:billbuddy/base/app_theme.dart';
import 'package:billbuddy/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/number_input_formatter.dart';

OutlineInputBorder outlineInputBorder(BuildContext context) {
  return OutlineInputBorder(
    borderSide: BorderSide(color: colorScheme(context).outline, width: 1),
  );
}

InputDecoration inputDecoration(BuildContext context, {double padding = 0, Widget? label, Widget? prefix}) {
  return InputDecoration(
      counterText: "",
      label: label,
      border: outlineInputBorder(context),
      contentPadding: EdgeInsets.all(padding),
      prefix: prefix);
}

TextEditingController textEditingControllerWithValue(String text, {bool shouldFormatNumber = false}) {
  String formatted = shouldFormatNumber ? formatThousands(text) : text;
  return TextEditingController.fromValue(
      TextEditingValue(text: formatted)
  )..selection = TextSelection.collapsed(offset: formatted.length);
}

List<TextInputFormatter> numberInputFormatters() {
  return [
    FilteringTextInputFormatter.digitsOnly,
    NumberInputFormatter()
  ];
}

TextButton primaryTextButton(BuildContext context,
    {required void Function() onPressed, required String text}) {
  return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: textThemePrimary(context).titleSmall,
      ),
      style: primaryButtonStyle(context));
}

ButtonStyle primaryButtonStyle(BuildContext context) {
  return TextButton.styleFrom(
      padding: EdgeInsets.only(top: 12, bottom: 12),
      backgroundColor: colorScheme(context).primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ));
}