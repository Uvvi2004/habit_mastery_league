import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/habit.dart';

// This class handles all database operations (SQLite)
// It follows a singleton pattern so only one instance exists
class DBHelper {
  static final DBHelper instance = DBHelper._init();
  static Database? _database;

  DBHelper._init();

  // This getter returns the database instance
  // If it doesn't exist yet, it initializes it
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('habits.db');
    return _database!;
  }

  // This function initializes the database file
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath(); // gets device storage path
    final path = join(dbPath, filePath); // creates full database path

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB, // runs only when DB is first created
    );
  }

  // This function creates the habits table
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE habits (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        description TEXT,
        progress INTEGER
      )
    ''');
  }

  // CREATE
  // Inserts a new habit into the database
  Future<int> insertHabit(Habit habit) async {
    final db = await instance.database;
    return await db.insert('habits', habit.toMap());
  }

  // READ
  // Retrieves all habits from the database
  Future<List<Habit>> getHabits() async {
    final db = await instance.database;
    final result = await db.query('habits');

    // Converts raw database data into Habit objects
    return result.map((json) => Habit.fromMap(json)).toList();
  }

  // UPDATE
  // Updates an existing habit using its id
  Future<int> updateHabit(Habit habit) async {
    final db = await instance.database;
    return await db.update(
      'habits',
      habit.toMap(),
      where: 'id = ?', // ensures only the correct row is updated
      whereArgs: [habit.id],
    );
  }

  // DELETE
  // Deletes a single habit by id
  Future<int> deleteHabit(int id) async {
    final db = await instance.database;
    return await db.delete(
      'habits',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // DELETE ALL
  // Removes all habits from the table
  Future<int> deleteAllHabits() async {
    final db = await DBHelper.instance.database;
    return await db.delete('habits');
  }
}