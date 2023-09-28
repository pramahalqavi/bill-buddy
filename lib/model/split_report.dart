import 'bill_item.dart';

class SplitReport {
  int id;
  String participant;
  List<BillItem> items;
  double tax;
  double service;
  double discounts;
  double others;
  double total;

  SplitReport({
    required this.id,
    required this.participant,
    required this.items,
    required this.tax,
    required this.service,
    required this.discounts,
    required this.others,
    required this.total
  });
}