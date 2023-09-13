import 'package:billbuddy/database/app_database.dart';

import '../database/entity/bill_entity.dart';

class BillRepository {
  AppDatabase _database;

  BillRepository(this._database);

  Future<List<BillEntity>> getBills() {
    return _database.billDao.getAllBill();
  }
}