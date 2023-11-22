
import 'package:billbuddy/database/entity/bill_entity.dart';
import 'package:floor/floor.dart';

@dao
abstract class BillDao {
  @Query("SELECT * FROM Bill ORDER BY updatedDate DESC")
  Future<List<BillEntity>> getAllBill();

  @insert
  Future<void> insertBill(BillEntity bill);
  
  @Query("DELETE FROM Bill WHERE id = :id")
  Future<void> deleteBill(int id);

  @update
  Future<void> updateBill(BillEntity bill);
}