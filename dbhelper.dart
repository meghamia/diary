
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  // Table and column names
  static const String tableTasks = 'tasks'; //table name
  static const String columnId = 'id';
  static const String columnTask = 'task';
  static const String columnIsChecked = 'is_checked';
  static const String columnProgress = 'progress';
  static const String columnCreatedDate = 'created_date';
  static const String columnUpdatedDate = 'updated_date';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'tasks.db');

    return await openDatabase(path, version: 1, onCreate: (db, version) {
      return db.execute('''
          CREATE TABLE $tableTasks(
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnTask TEXT,
            $columnIsChecked INTEGER,
            $columnProgress REAL,
            $columnCreatedDate TEXT,
            $columnUpdatedDate TEXT
          )
          ''');
    });
  }

  Future<int?> insertTask(
      String task, bool isChecked, double progress, String createdDate) async {
    final db = await database;
    final result = await db.insert(
      'tasks',
      {
        'task': task,
        'is_checked': isChecked ? 1 : 0,
        'progress': progress,
        'created_date': createdDate,
        'updated_date': createdDate, // Use the same format for consistency
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return result;
  }

  Future<void> updateTask(String oldTask, String newTask, bool isChecked,
      double progress, String updatedDate) async {
    final db = await database;
    await db.update(
      tableTasks,
      {
        columnTask: newTask,
        columnIsChecked: isChecked ? 1 : 0,
        columnProgress: progress,
        columnUpdatedDate: updatedDate,
      },
      where: '$columnTask = ?',
      whereArgs: [oldTask],
    );
  }

  Future<void> deleteTask(String task) async {
    final db = await database;
    await db.delete(
      tableTasks,
      where: '$columnTask = ?',
      whereArgs: [task],
    );
  }

  Future<List<Map<String, dynamic>>> getTasks() async {
    final db = await database;
    return await db.query(tableTasks);
  }

  Future<List<Map<String, dynamic>>> getTaskProgressForRange(
      String taskName, String startDate, String endDate) async {
    final db = await database;
    return await db.query(
      tableTasks,
      columns: [columnTask, columnProgress, columnCreatedDate],
      where: '$columnTask = ? AND $columnCreatedDate BETWEEN ? AND ?',
      whereArgs: [taskName, startDate, endDate],
    );
  }

  Future<List<double>> getTaskProgress(
      String taskName, String startDate, String endDate) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      tableTasks,
      columns: [columnProgress],
      where: '$columnTask = ? AND $columnCreatedDate BETWEEN ? AND ?',
      whereArgs: [taskName, startDate, endDate],
    );

    // Extract progress values from the result
    return result.map((data) => (data[columnProgress] as double)).toList();
  }
}


