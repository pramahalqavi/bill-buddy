import 'package:billbuddy/model/split_report.dart';

import 'bill_item.dart';

class Bill {
  int? id;
  String title;
  DateTime billDate;
  List<BillItem> items;
  List<String> participants;
  int tax;
  int service;
  int discount;
  int others;
  int total;

  Bill({this.id, this.title = "", required this.billDate, this.items = const [],
    this.participants = const [""], this.tax = 0, this.service = 0,
    this.discount = 0, this.others = 0, this.total = 0});

  int getSubtotal() {
    int subtotal = 0;
    for (var item in items) { subtotal += (item.price * item.quantity); }
    return subtotal;
  }

  void updateOthers() {
    others = total - getSubtotal() - tax - service + discount;
  }

  void updateTotal() {
    total = getSubtotal() + tax + service - discount + others;
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
    int subtotal = getSubtotal();
    double portion = subtotal > 0 ? participantSubtotal / getSubtotal() : 1 / participants.length;
    double participantTax = tax * portion;
    double participantService = service * portion;
    double participantOthers = others * portion;
    double participantDiscounts = discount * portion;
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