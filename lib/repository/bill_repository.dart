import 'package:billbuddy/database/app_database.dart';
import 'package:billbuddy/utils/bill_transformer.dart';

import '../model/bill.dart';

class BillRepository {
  AppDatabase _database;

  BillRepository(this._database);

  Future<List<Bill>> getBills() {
    return _database.billDao.getAllBill().then(
            (value) => value.map((e) => BillTransformer.transformToBill(e)).toList()
    );
  }

  Future<void> insertBill(Bill bill) {
    return _database.billDao.insertBill(BillTransformer.transformToBillEntity(bill));
  }

  Future<void> deleteBill(int billId) {
    return _database.billDao.deleteBill(billId);
  }

  Future<void> updateBill(Bill bill) {
    var entity = BillTransformer.transformToBillEntity(bill);
    return _database.billDao.updateBill(entity);
  }
}