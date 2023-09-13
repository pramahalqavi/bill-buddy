import 'dart:async';
import 'package:billbuddy/database/dao/bill_dao.dart';
import 'package:floor/floor.dart';
import 'entity/bill_entity.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
part 'app_database.g.dart';

@Database(version: 1, entities: [BillEntity])
abstract class AppDatabase extends FloorDatabase {
  BillDao get billDao;
}