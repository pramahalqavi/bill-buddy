import 'package:floor/floor.dart';

@Entity(tableName: "Bill")
class BillEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  @ColumnInfo(name: "title")
  final String title;
  @ColumnInfo(name: "billDate")
  final int billDate;
  @ColumnInfo(name: "updatedDate")
  final int updatedDate;
  @ColumnInfo(name: "tax")
  final int tax;
  @ColumnInfo(name: "service")
  final int service;
  @ColumnInfo(name: "discounts")
  final int discounts;
  @ColumnInfo(name: "others")
  final int others;
  @ColumnInfo(name: "total")
  final int total;

  @ColumnInfo(name: "items")
  final String items;
  @ColumnInfo(name: "participants")
  final String participants;

  BillEntity(
      {this.id,
      required this.title,
      required this.billDate,
      required this.updatedDate,
      required this.tax,
      required this.service,
      required this.discounts,
      required this.others,
      required this.total,
      required this.items,
      required this.participants});
}