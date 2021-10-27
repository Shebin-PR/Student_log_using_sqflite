
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:studentsdetails/sqflite/datamodel.dart';

class DB {
  Future<Database> initDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path,"MYDb1.db"),
      onCreate: (db, version) async{
        await db.execute(
            """
        CREATE TABLE MYTable1(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        dob TEXT NOT NULL,
        age TEXT NOT NULL,
        domain TEXT NOT NULL,
        imagePath TEXT NOT NULL
        )
        """
        );
      },
      version: 1,
    );
  }

  Future<bool> insertData(DataModel dataModel) async{
    final Database db = await initDB();
    db.insert("MYTable1", dataModel.toMap());
    return true;
  }

  Future<List<DataModel>> getData() async {
    final Database db = await initDB();
    final List<Map<String,Object?>> datas = await db.query("MYTable1");
    return datas.map((e) => DataModel.fromMap(e)).toList();
  }

  Future<void> update(DataModel dataModel, int id) async{
    final Database db = await initDB();
    await db.update("MYTable1", dataModel.toMap(),where: "id=?",whereArgs: [id]);
  }

  Future<void> delete(int id) async{
    final Database db = await initDB();
    await db.delete("MYTable1", where: "id=?",whereArgs: [id]);
  }

  Future<List<DataModel>> searchData(String keyword) async {
    final Database db = await initDB();
    List<Map<String,Object?>> datas = await db.query("MYTable1",where: 'name LIKE ?',whereArgs: ['%$keyword%']);
    return datas.map((e) => DataModel.fromMap(e)).toList();

  }


}