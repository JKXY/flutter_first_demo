import 'package:FlutterDemo/bean/pocketBookBean.dart';
import 'package:FlutterDemo/bean/todoBean.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class PocketDatabaseHelper {
  static final PocketDatabaseHelper _instance = PocketDatabaseHelper.internal();

  factory PocketDatabaseHelper() => _instance;
  final String tableName = "table_pocket_book";
  final String tableNameRecord = "table_pocket_book_record";
  final String tableNameTodo = "table_todo";
  final String columnId = "id";
  final String columnDate = "date";
  final String columnIncome = "income";
  final String columnExpenditure = "expenditure";
  final String columnType = "type";
  final String columnMoney = "money";
  final String columnName = "name";

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  PocketDatabaseHelper.internal();

  initDb() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'sqflite.db');
    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  //创建数据库表
  void _onCreate(Database db, int version) async {
    await db.execute(
        "create table $tableName($columnId integer primary key autoincrement ,$columnDate text not null ,$columnIncome text ,$columnExpenditure text )");

    await db.execute(
        "create table $tableNameRecord($columnId integer primary key autoincrement ,$columnType integer not null default 2 ,$columnDate text not null ,$columnMoney text ,$columnName text )");

    await db.execute(
        "create table $tableNameTodo($columnId integer primary key autoincrement ,$columnType integer not null default 2 ,$columnDate text not null ,$columnName text )");
  }

//保存
  Future<int> saveItem(PocketBookRecord record) async {
    var dbClient = await db;
    int res = await dbClient.insert("$tableNameRecord", record.toMap());
    if (res > 0) {
      var result = await dbClient.rawQuery(
          "SELECT * FROM $tableName WHERE $columnDate = '${record.date}' ");
      if (result.length > 0) {
        var data = PocketBookBean.fromMap(result.first);
        if (record.type == 1) {
          data.income =
              (double.tryParse(data.income) + double.tryParse(record.money))
                  .toStringAsFixed(2);
        } else {
          data.expenditure = (double.tryParse(data.expenditure) +
                  double.tryParse(record.money))
              .toStringAsFixed(2);
        }
        res = await dbClient.update("$tableName", data.toDbMap(),
            where: "$columnId = ?", whereArgs: [result.first['$columnId']]);
      } else {
        var data = PocketBookBean();
        data.date = record.date;
        if (record.type == 1) {
          data.income = record.money;
          data.expenditure = '0';
        } else {
          data.income = '0';
          data.expenditure = record.money;
        }
        res = await dbClient.insert("$tableName", data.toDbMap());
      }
    }
    return res;
  }

  //查询
  Future<PocketBookList> getTotalList(int page) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableName ORDER BY $columnId DESC");
//    var result = await dbClient.rawQuery("SELECT * FROM $tableName ORDER BY $columnId DESC LIMIT ${page*20} OFFSET 20");
    var data = PocketBookList.fromJson(result.toList());
    await Future.forEach(data.list, (item) async {
      var res = await dbClient.rawQuery(
          "SELECT * FROM $tableNameRecord WHERE $columnDate = '${item.date}' ORDER BY $columnId DESC");
      item.record =
          res.toList().map((o) => PocketBookRecord.fromMap(o)).toList();
    });
    return data;
  }


  //保存Todo
  Future<int> saveTodoItem(TodoBean bean) async {
    var dbClient = await db;
    int res = await dbClient.insert("$tableNameTodo", bean.toDbMap());
    return res;
  }


  //保存Todo
  Future<int> updataTodoItem(TodoBean bean) async {
    var dbClient = await db;
    int res = await dbClient.update("$tableNameTodo", bean.toDbMap(),
        where: '$columnId = ?', whereArgs: [bean.id]);
    return res;
  }

  //查询Todo
  Future<TodoBeanList> getTodoList(bool isShowComplet) async {
    var dbClient = await db;
    var sqlStr = "";
    if(isShowComplet)
      sqlStr = "SELECT * FROM $tableNameTodo";
    else
      sqlStr = "SELECT * FROM $tableNameTodo WHERE $columnType = 2";
    var result = await dbClient.rawQuery(sqlStr);
    var data = TodoBeanList.fromJson(result.toList());
    return data;
  }


  //关闭
  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
