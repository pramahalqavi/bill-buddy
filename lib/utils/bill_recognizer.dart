import 'dart:math';

import 'package:billbuddy/model/bill_item.dart';
import 'package:billbuddy/utils/bill_scan_helper.dart';
import 'package:billbuddy/utils/utils.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../model/bill.dart';
import 'constants.dart';

class BillRecognizer {
  final RegExp priceRegex = RegExp(Constants.priceRegex);
  final RegExp subtotalRegex = RegExp(Constants.subtotalRegex);
  final RegExp totalRegex = RegExp(Constants.totalRegex);
  final RegExp taxRegex = RegExp(Constants.taxRegex);
  final RegExp serviceRegex = RegExp(Constants.serviceRegex);
  final RegExp discountRegex = RegExp(Constants.discountRegex);
  final RegExp qtyRegex = RegExp(Constants.qtyRegex);
  final RegExp qtyNumberRegex = RegExp(Constants.qtyNumberRegex);
  final RegExp itemNameRegex = RegExp(Constants.itemNameRegex);
  final RegExp currencyRegex = RegExp(Constants.currencyRegex);

  final double priceBottomThreshold = 0.005;
  final double priceTopThreshold = 10;

  RecognizedText recognizedText;
  late List<String> lines;
  bool flag = false;

  BillRecognizer(this.recognizedText) {
    lines = BillScanHelper(recognizedText).constructLines();
    for (String line in lines) {
      print(line);
    }
  }

  Bill recognize() {
    String title = _findTitle(recognizedText);
    int total = _findSummaryValue(totalRegex, null);
    int tax = _findTax(lines, total);
    int service = _findSummaryValue(serviceRegex, total);
    int discount = _findSummaryValue(discountRegex, total);
    _findSummaryValue(subtotalRegex, total);
    List<BillItem> items = _findItems(lines, total);
    int subtotal = 0;
    items.forEach((element) => subtotal += element.quantity * element.price);
    int others = total - (tax + service - discount + subtotal);
    return Bill(
      title: title,
      billDate: DateTime.now(),
      tax: tax,
      service: service,
      discounts: discount,
      others: others,
      total: total,
      items: items
    );
  }

  String _findTitle(RecognizedText text) {
    String title = "";
    for (TextLine line in text.blocks.first.lines) {
      title = "${line.text.trim()} ";
    }
    return title.trim();
  }

  List<BillItem> _findItems(List<String> lines, int total) {
    int calculatedTotal = 0;
    List<BillItem> items = [];
    for (int i = 0; i < lines.length; ++i) {
      if (priceRegex.hasMatch(lines[i])) {
        int priceNum = _getPriceFromLine(lines[i], total);
        int qtyNum = _getQtyFromLine(lines[i]);
        if (qtyNum == 0 && i < lines.length - 1) {
          qtyNum = _getQtyFromLine(lines[i + 1]);
        }
        String itemName = _getItemNameFromLine(lines[i]);
        if (itemName.length < 3 && i > 0) {
          itemName = _getItemNameFromLine(lines[i - 1]);
        }
        print("Items itemName $itemName priceNum $priceNum qtyNum $qtyNum");
        if (priceNum > 0 && itemName.isNotEmpty && priceNum > total * priceBottomThreshold) {
          bool shouldAdd = false;
          if (qtyNum == 0) qtyNum = 1;
          if (priceNum * qtyNum + calculatedTotal <= total * priceTopThreshold) {
            shouldAdd = true;
            calculatedTotal += priceNum * qtyNum;
          } else if (priceNum + calculatedTotal <= total * priceTopThreshold) {
            shouldAdd = true;
            calculatedTotal += priceNum;
            qtyNum = 1;
          }
          if (shouldAdd) {
            print("should add");
            items.add(
                BillItem(
                    name: itemName,
                    price: priceNum,
                    quantity: qtyNum,
                    amount: priceNum * qtyNum,
                    participantsId: {}
                )
            );
          }
        }
      }
    }
    return items;
  }

  int _findTax(List<String> lines, int total) {
    for (var i = lines.length - 1; i >= 0; --i) {
      if (taxRegex.hasMatch(lines[i])) {
        int tax = _getPriceFromLine(lines[i], total);
        if (tax == 0 && i < lines.length - 1) {
          tax = max(tax, _getPriceFromLine(lines[i + 1], total));
          if (tax > 0) lines.removeAt(i + 1);
          else lines.removeAt(i);
        } else lines.removeAt(i);
        return tax;
      }
    }
    return 0;
  }

  int _findSummaryValue(RegExp labelRegex, int? total) {
    for (var i = lines.length - 1; i >= 0; --i) {
      int removeIdx = -1;
      if (labelRegex.hasMatch(lines[i])) {
        int match = 0;
        if (priceRegex.hasMatch(lines[i])) {
          match = _getPriceFromLine(lines[i], total);
          if (!_isPriceInRange(match, total)) continue;
          removeIdx = i;
        } else if (i < lines.length - 1 && priceRegex.hasMatch(lines[i + 1])) {
          match = _getPriceFromLine(lines[i + 1], total);
          if (!_isPriceInRange(match, total)) continue;
          removeIdx = i + 1;
        }
        if (removeIdx != -1) {
          lines.removeAt(removeIdx);
        }
        return match;
      }
    }
    return 0;
  }

  bool _isPriceInRange(int input, int? total) {
    if (total == null) return true;
    return input > priceBottomThreshold * total && input < priceTopThreshold * total;
  }

  int _getPriceFromLine(String input, int? total) {
    int max = 0;
    priceRegex.allMatches(input).forEach((element) {
      int num = stringToInt(_getMatchString(element));
      if (num > max && _isPriceInRange(num, total)) {
        max = num;
      }
    });
    return max;
  }

  int _getQtyFromLine(String input) {
    int mn = 999;
    qtyRegex.allMatches(input).forEach((element) {
      int match = stringToInt(_getMatchString(element));
      if (match > 0) {
        mn = min(mn, match);
      }
    });
    return (mn == 999) ? 0 : mn;
  }

  String _getItemNameFromLine(String input) {
    String name = "";
    itemNameRegex.allMatches(input).forEach((element) {
      String match = _getMatchString(element);
      if (match.length > name.length) name = match;
    });
    String splitted = name.split("@").first;
    String temp = splitted;
    currencyRegex.allMatches(temp).forEach((element) {
      splitted = splitted.replaceAll(_getMatchString(element), "");
    });
    name = splitted.trim();
    return name;
  }

  String _getMatchString(RegExpMatch match) {
    return match.input.substring(match.start, match.end);
  }
}