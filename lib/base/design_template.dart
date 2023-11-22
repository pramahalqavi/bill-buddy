import 'package:billbuddy/base/app_theme.dart';
import 'package:billbuddy/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/number_input_formatter.dart';

OutlineInputBorder outlineInputBorder(BuildContext context, bool isError) {
  var borderColor = isError ? colorScheme(context).error : colorScheme(context).outline;
  return OutlineInputBorder(
    borderSide: BorderSide(color: borderColor, width: 1),
  );
}

InputDecoration inputDecoration(BuildContext context, {double padding = 0, Widget? label, Widget? prefix, bool isError = false}) {
  return InputDecoration(
      counterText: "",
      label: label,
      enabledBorder: outlineInputBorder(context, isError),
      border: outlineInputBorder(context, isError),
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

ButtonStyle primaryButtonStyle(BuildContext context, {double verticalPadding = 12}) {
  return TextButton.styleFrom(
      padding: EdgeInsets.only(top: verticalPadding, bottom: verticalPadding),
      backgroundColor: colorScheme(context).primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32.0),
      ));
}

TextStyle errorTextStyle(BuildContext context) {
  return TextStyle(
    color: colorScheme(context).error
  );
}

BoxDecoration curvedBoxDecoration() {
  return BoxDecoration(
      border: Border.all(
        color: Colors.white,
      ),
      borderRadius: BorderRadius.all(Radius.circular(16))
  );
}