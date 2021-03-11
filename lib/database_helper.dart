import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseName = "appDb.db";
  static final _databaseVersion = 1;

  String queryCreateTable4 = '''
	CREATE TABLE "geo" (
	"contact_id"	INTEGER,
	"lat"	TEXT,
	"lng"	TEXT
);
);''';
  String queryCreateTable3 = '''
  CREATE TABLE "address" (
	"contact_id"	INTEGER,
	"street"	TEXT,
	"suite"	TEXT,
	"city"	TEXT,
	"zipcode"	TEXT
);''';
  String queryCreateTable2 = '''
  CREATE TABLE "company" (
	"contact_id"	INTEGER,
	"name"	INTEGER,
	"catchPhrase"	INTEGER,
	"bs"	INTEGER
);''';
  String queryCreateTable1 = '''
  CREATE TABLE "contacts" (
	"id"	INTEGER,
	"name"	TEXT,
	"username"	TEXT,
	"email"	TEXT,
	"profile_image"	TEXT,
	"phone"	TEXT,
	"website"	TEXT
);
  ''';

  String tableContact = "contacts";
  String tableAddress = "address";
  String tableCompany = "company";
  String tableGeo = "geo";

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(queryCreateTable1);
    await db.execute(queryCreateTable2);
    await db.execute(queryCreateTable3);
    await db.execute(queryCreateTable4);
  }

  Future<int> insert(String table, Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> getAllRows(String table) async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<List<Map<String, dynamic>>> getRows(
      String table, int contactId) async {
    Database db = await instance.database;
    return await db
        .rawQuery("select * from $table where contact_id = $contactId");
  }

  Future<String> getCompanyName(int contactId) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> l = await db
        .rawQuery("select * from company where contact_id = $contactId");
    return l[0]['name'];
  }
}
