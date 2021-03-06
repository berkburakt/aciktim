import 'dart:io';
import 'package:aciktim/model/address_item.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class AddressDatabase {
  static final AddressDatabase _instance = new AddressDatabase.internal();

  factory AddressDatabase() => _instance;

  final String tableName = "addressTbl";
  final String columnId = "id";
  final String columnTitle = "title";
  final String columnBody = "body";

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  AddressDatabase.internal();

  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "address_db.db");
    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $tableName(id INTEGER PRIMARY KEY, $columnTitle TEXT, $columnBody TEXT)");
    print("Table is created");
  }

//insertion
  Future<int> saveItem(AddressItem item) async {
    var dbClient = await db;
    int res = await dbClient.insert("$tableName", item.toMap());
    print(res.toString());
    return res;
  }

  //Get
  Future<List> getItems() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableName"); //ASC

    return result.toList();

//    if (result.length == 0) return [];
//    var users = [];
//
//    for (Map<String, dynamic> map in result) {
//       users.add(new User.fromMap(map));
//    }
//
//    return users;
  }

  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery("SELECT COUNT(*) FROM $tableName"));
  }

//
  Future<AddressItem> getItem(int id) async {
    var dbClient = await db;
    var result =
        await dbClient.rawQuery("SELECT * FROM $tableName WHERE id = $id");
    if (result.length == 0) return null;
    return new AddressItem.fromMap(result.first);
  }

  //deletion
//  Future<int> deleteItem(int id) async {
//    var dbClient = await db;
//    var result = await dbClient.rawQuery("DELETE FROM $tableName WHERE id = $id");
//    if (result.length == 0) return null;
//    return result.first as int;
//  }

  Future<int> deleteItem(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete(tableName, where: "$columnId = ?", whereArgs: [id]);
  }

  Future<int> updateItem(AddressItem item) async {
    var dbClient = await db;
    return await dbClient.update("$tableName", item.toMap(),
        where: "$columnId = ?", whereArgs: [item.id]);
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
