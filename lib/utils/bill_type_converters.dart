import 'dart:convert';

import 'package:billbuddy/model/bill_item.dart';
import 'package:floor/floor.dart';

class BillItemsTypeConverter extends TypeConverter<List<BillItem>, String> {
  @override
  List<BillItem> decode(String databaseValue) {
    List<BillItem> items = List<BillItem>.from(jsonDecode(databaseValue));
    return items;
  }

  @override
  String encode(List<BillItem> value) {
    return jsonEncode(value);
  }
}

class StringsTypeConverter extends TypeConverter<List<String>, String> {
  @override
  List<String> decode(String databaseValue) {
    return List<String>.from(jsonDecode(databaseValue));
  }

  @override
  String encode(List<String> value) {
    return jsonEncode(value);
  }
}