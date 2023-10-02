import 'bill_item.dart';

class SplitReport {
  int id;
  String participant;
  List<BillItem> items;
  double subtotal;
  double tax;
  double service;
  double discounts;
  double others;
  double total;

  SplitReport({
    required this.id,
    required this.participant,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.service,
    required this.discounts,
    required this.others,
    required this.total
  });
}