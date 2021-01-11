import 'package:hamro_gadgets/Constants/wishlist.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper2 {
  static final _databaseName = "wishlistdb.db";
  static final _databaseVersion = 1;
  static final table = 'Wishlist';
  static final columnId = 'id';
  static final columnProductName = 'productName';
  static final columnImageUrl = 'imgUrl';
  static final columnPrice = 'price';

//  static final columnDetail = 'details';

  // make this a singleton class
  DatabaseHelper2._privateConstructor();
  static final DatabaseHelper2 instance = DatabaseHelper2._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  onCreate() async {
    Database db = await instance.database;
    db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnProductName TEXT NOT NULL,
            $columnImageUrl TEXT NOT NULL,
            $columnPrice TEXT NOT NULL
          )
          ''');
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnProductName TEXT NOT NULL,
            $columnImageUrl TEXT NOT NULL,
            $columnPrice TEXT NOT NULL
          )
          ''');
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(Wishlist item) async {
    Database db = await instance.database;
    return await db.insert(table, {
      'productName': item.productName,
      'imgUrl': item.imgUrl,
      'price': item.price
    });
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<List<Map<String, dynamic>>> queryRows(name) async {
    Database db = await instance.database;
    var x = await db
        .query(table, where: "$columnProductName LIKE '%$name%'")
        .catchError((e) {
      print(e);
    });
    print(x.toString());
    return await db
        .query(table, where: "$columnProductName LIKE '%$name%'")
        .catchError((e) {
      print(e);
    });
  }

  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  Future<int> check(String name) async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery(
        'SELECT COUNT(*) FROM $table WHERE $columnProductName = $name'));
  }

  Future<int> update(Wishlist item) async {
    Database db = await instance.database;
    String productName = item.toMap()['productName'];

    return await db.update(table, item.toMap(),
        where: '$columnProductName = ?', whereArgs: [productName]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(String name) async {
    Database db = await instance.database;
    return await db
        .delete(table, where: '$columnProductName = ?', whereArgs: [name]);
  }
}
