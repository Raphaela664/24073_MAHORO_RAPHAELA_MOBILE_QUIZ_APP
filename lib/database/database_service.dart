import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }
  Future<Database> _initDatabase() async {
  try {
    final path = join(await getDatabasesPath(), 'quizzes_db.db');
    final db = await openDatabase(
      path,
      onCreate: _onCreate,
      version: 2,
    );
    return db;
  } catch (e) {
    print('Error initializing database: $e');
    rethrow;
  }
}

  Future<void> _onCreate(Database db, int version) async {
    try {
      await db.execute(
        'CREATE TABLE quiz(id TEXT PRIMARY KEY, title TEXT)',
      );
      await db.execute(
        'CREATE TABLE questions(id TEXT PRIMARY KEY, quiz_id TEXT, question_description TEXT, option1 TEXT, option2 TEXT, option3 TEXT,  correct_answer_index INTEGER)',
      );
     
       print('print tables successfully created');
    } catch (e) {
      print('Error creating tables: $e');
      rethrow; // Rethrow the error to propagate it to the caller
    }
  }

  
}
