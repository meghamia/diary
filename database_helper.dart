import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;
  final String tableName = 'tasks';
  final String columnId = 'id';
  final String columnTask = 'task';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'tasks.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE $tableName($columnId INTEGER PRIMARY KEY AUTOINCREMENT, $columnTask TEXT)',
        );
      },
    );
  }

  Future<int> insertTask(String task) async {
    final db = await database;
    return await db.insert(
      tableName,
      {columnTask: task},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getTasks() async {
    final db = await database;
    return await db.query(tableName);
  }

  Future<int> deleteTask(String task) async {
    final db = await database;
    return await db.delete(
      tableName,
      where: '$columnTask = ?',
      whereArgs: [task],
    );
  }

  Future<int> updateTask(String oldTask, String newTask) async {
    Database db = await database;
    return await db.update(
      tableName,
      {columnTask: newTask},
      where: '$columnTask = ?',
      whereArgs: [oldTask],
    );
  }
}
