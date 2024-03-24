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
    final path = join(await getDatabasesPath(), 'quiz_db.db');
    final db = await openDatabase(
      path,
      onCreate: _onCreate,
      version: 1,
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
        'CREATE TABLE questions(id TEXT PRIMARY KEY, quizId TEXT, question_description TEXT, correctAnswerIndex INTEGER)',
      );
      await db.execute(
        'CREATE TABLE options(id INTEGER PRIMARY KEY, questionId TEXT, option TEXT)',
      );
      await db.execute(
        'CREATE TABLE quiz_questions_options(quizId TEXT, questionId TEXT, optionId INTEGER, FOREIGN KEY(quizId) REFERENCES quizzes(id), FOREIGN KEY(questionId) REFERENCES questions(id), FOREIGN KEY(optionId) REFERENCES options(id))',
      );
       print('print tables successfully created');
    } catch (e) {
      print('Error creating tables: $e');
      rethrow; // Rethrow the error to propagate it to the caller
    }
  }

  
}
