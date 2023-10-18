import 'dart:convert';

import 'package:billbuddy/database/entity/bill_entity.dart';
import 'package:billbuddy/model/bill_item.dart';

import '../model/bill.dart';

class BillTransformer {
  static BillEntity transformToBillEntity(Bill bill) {
    return BillEntity(
        id: bill.id,
        title: bill.title,
        billDate: bill.billDate.millisecondsSinceEpoch,
        updatedDate: DateTime.now().millisecondsSinceEpoch,
        tax: bill.tax,
        service: bill.service,
        discounts: bill.discounts,
        others: bill.others,
        total: bill.total,
        items: jsonEncode(bill.items),
        participants: jsonEncode(bill.participants)
    );
  }

  static Bill transformToBill(BillEntity bill) {
    List<dynamic> parsedListJson = jsonDecode(bill.items);
    List<BillItem> itemList = List<BillItem>.from(
        parsedListJson.map<BillItem>((dynamic i) => BillItem.fromJson(i))
    );
    return Bill(
        id: bill.id,
        title: bill.title,
        billDate: DateTime.fromMillisecondsSinceEpoch(bill.billDate),
        tax: bill.tax,
        service: bill.service,
        discounts: bill.discounts,
        others: bill.others,
        total: bill.total,
        items: itemList,
        participants: List<String>.from(jsonDecode(bill.participants))
    );
  }
}