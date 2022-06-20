import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = 'taskist.db';
  static const _databaseVersion = 1;
  static const _taskTable = 'Tasks';
  static const _numberOfTasks = 'Detail';
  static Database? _database;

  //Singleton Pattern

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    return _database ?? await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    String path = await getDatabasesPath();
    String dbPath = join(path, _databaseName);
    return await openDatabase(
      dbPath,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
        CREATE TABLE $_taskTable(
          id INTEGER PRIMARY KEY UNIQUE AUTOINCREMENT,
          name TEXT,
          taskCode INTEGER UNIQUE
        );
''');
    await db.execute('''
        CREATE TABLE $_numberOfTasks(
          id INTEGER PRIMARY KEY UNIQUE AUTOINCREMENT,
          name TEXT,
          taskCode INTEGER UNIQUE
        );
''');
  }
}
