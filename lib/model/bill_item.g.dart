// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BillItem _$BillItemFromJson(Map<String, dynamic> json) => BillItem(
      name: json['name'] as String? ?? "",
      quantity: json['quantity'] as int? ?? 1,
      price: json['price'] as int? ?? 0,
      amount: json['amount'] as int? ?? 0,
      participantsId: (json['participantsId'] as List<dynamic>)
          .map((e) => e as int)
          .toSet(),
    );

Map<String, dynamic> _$BillItemToJson(BillItem instance) => <String, dynamic>{
      'name': instance.name,
      'quantity': instance.quantity,
      'price': instance.price,
      'amount': instance.amount,
      'participantsId': instance.participantsId.toList(),
    };
