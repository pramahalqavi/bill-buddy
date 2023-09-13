import 'package:floor/floor.dart';

@Entity(tableName: "Bill")
class BillEntity {
  @PrimaryKey(autoGenerate: true)
  final int id;

  BillEntity(this.id);
}