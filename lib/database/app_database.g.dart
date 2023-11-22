// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  BillDao? _billDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Bill` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `title` TEXT NOT NULL, `billDate` INTEGER NOT NULL, `updatedDate` INTEGER NOT NULL, `tax` INTEGER NOT NULL, `service` INTEGER NOT NULL, `discounts` INTEGER NOT NULL, `others` INTEGER NOT NULL, `total` INTEGER NOT NULL, `items` TEXT NOT NULL, `participants` TEXT NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  BillDao get billDao {
    return _billDaoInstance ??= _$BillDao(database, changeListener);
  }
}

class _$BillDao extends BillDao {
  _$BillDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _billEntityInsertionAdapter = InsertionAdapter(
            database,
            'Bill',
            (BillEntity item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'billDate': item.billDate,
                  'updatedDate': item.updatedDate,
                  'tax': item.tax,
                  'service': item.service,
                  'discounts': item.discounts,
                  'others': item.others,
                  'total': item.total,
                  'items': item.items,
                  'participants': item.participants
                }),
        _billEntityUpdateAdapter = UpdateAdapter(
            database,
            'Bill',
            ['id'],
            (BillEntity item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'billDate': item.billDate,
                  'updatedDate': item.updatedDate,
                  'tax': item.tax,
                  'service': item.service,
                  'discounts': item.discounts,
                  'others': item.others,
                  'total': item.total,
                  'items': item.items,
                  'participants': item.participants
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<BillEntity> _billEntityInsertionAdapter;

  final UpdateAdapter<BillEntity> _billEntityUpdateAdapter;

  @override
  Future<List<BillEntity>> getAllBill() async {
    return _queryAdapter.queryList(
        'SELECT * FROM Bill ORDER BY updatedDate DESC',
        mapper: (Map<String, Object?> row) => BillEntity(
            id: row['id'] as int?,
            title: row['title'] as String,
            billDate: row['billDate'] as int,
            updatedDate: row['updatedDate'] as int,
            tax: row['tax'] as int,
            service: row['service'] as int,
            discounts: row['discounts'] as int,
            others: row['others'] as int,
            total: row['total'] as int,
            items: row['items'] as String,
            participants: row['participants'] as String));
  }

  @override
  Future<void> deleteBill(int id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM Bill WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<void> insertBill(BillEntity bill) async {
    await _billEntityInsertionAdapter.insert(bill, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateBill(BillEntity bill) async {
    await _billEntityUpdateAdapter.update(bill, OnConflictStrategy.abort);
  }
}
