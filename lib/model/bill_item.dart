import 'package:json_annotation/json_annotation.dart';

part 'bill_item.g.dart';

@JsonSerializable(explicitToJson: true)
class BillItem {
  String name;
  int quantity;
  int price;
  int amount;
  Set<int> participantsId;

  BillItem({this.name = "", this.quantity = 1, this.price = 0, this.amount = 0, required this.participantsId});

  Map<String, dynamic> toJson() => _$BillItemToJson(this);

  factory BillItem.fromJson(Map<String, dynamic> json) {
    return _$BillItemFromJson(json);
  }

  int getTotalPrice() {
    return quantity * price;
  }

  double getAmountPerParticipant() {
    return amount / participantsId.length;
  }

  double getQuantityPerParticipant() {
    return quantity / participantsId.length;
  }
}