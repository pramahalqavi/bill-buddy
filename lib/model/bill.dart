import 'bill_item.dart';

class Bill {
  String title;
  DateTime billDate;
  List<BillItem> items;
  int tax;
  int service;
  int discounts;
  int others;
  int total;

  Bill({this.title = "", required this.billDate, this.items = const [
  ], this.tax = 0, this.service = 0, this.discounts = 0, this.others = 0, this.total = 0});

  int getSubtotal() {
    int subtotal = 0;
    for (var item in items) { subtotal += (item.price * item.quantity); }
    return subtotal;
  }

  void updateOthers() {
    others = total - getSubtotal() - tax - service + discounts;
  }

  void updateTotal() {
    total = getSubtotal() + tax + service - discounts + others;
  }
}