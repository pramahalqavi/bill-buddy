import 'package:billbuddy/model/split_report.dart';

import 'bill_item.dart';

class Bill {
  String title;
  DateTime billDate;
  List<BillItem> items;
  List<String> participants;
  int tax;
  int service;
  int discounts;
  int others;
  int total;

  Bill({this.title = "", required this.billDate, this.items = const [],
    this.participants = const [], this.tax = 0, this.service = 0,
    this.discounts = 0, this.others = 0, this.total = 0});

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

  List<BillItem> _getParticipantItems(int id) {
    return items.where((element) => element.participantsId.contains(id)).toList();
  }

  double _getParticipantSubtotal(int id) {
    double subtotal = 0;
    for (var item in items) {
      if (item.participantsId.contains(id)) {
        subtotal += item.getAmountPerParticipant();
      }
    }
    return subtotal;
  }

  SplitReport getParticipantReport(int id) {
    double participantSubtotal = _getParticipantSubtotal(id);
    double portion = participantSubtotal / getSubtotal();
    double participantTax = tax * portion;
    double participantService = service * portion;
    double participantOthers = others * portion;
    double participantDiscounts = discounts * portion;
    double participantTotal = participantSubtotal + participantTax +
        participantService + participantOthers - participantDiscounts;
    return SplitReport(
        id: id,
        participant: participants[id],
        items: _getParticipantItems(id),
        subtotal: participantSubtotal,
        tax: participantTax,
        service: participantService,
        discounts: participantDiscounts,
        others: participantOthers,
        total: participantTotal
    );
  }
}