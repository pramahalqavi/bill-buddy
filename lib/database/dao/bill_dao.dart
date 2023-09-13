
import 'package:billbuddy/database/entity/bill_entity.dart';
import 'package:floor/floor.dart';

@dao
abstract class BillDao {
  @Query("SELECT * FROM Bill")
  Future<List<BillEntity>> getAllBill();
}