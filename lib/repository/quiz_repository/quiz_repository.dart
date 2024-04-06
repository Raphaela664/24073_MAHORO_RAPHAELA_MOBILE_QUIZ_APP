import 'package:assignment_3/database/database_service.dart';
import 'package:assignment_3/models/quiz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class QuizRepository {
  static final QuizRepository instance = QuizRepository._privateConstructor();
  late final DatabaseHelper _databaseHelper;

  QuizRepository._privateConstructor() {
    _databaseHelper = DatabaseHelper.instance;
  }
    QuizRepository() {
     _databaseHelper = DatabaseHelper.instance;
  }

  final _db = FirebaseFirestore.instance;

  

  Future<void> createQuiz(BuildContext context, Quiz quiz) async {
    // Check connectivity status
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      // If no internet connection, save to SQLite
      await _saveQuizToLocalDatabase(context, quiz);
    } else {
      // If internet connection is available, save to Firebase
      await _saveQuizToFirebase(context, quiz);
    }
  }

  Future<void> _saveQuizToLocalDatabase(BuildContext context, Quiz quiz) async {
    final Database db = await _databaseHelper.database;
    try {
      await db.insert(
        'quiz',
        {
          'id': quiz.id,
          'title': quiz.title,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      quiz.questions.forEach((question) async {
        await db.insert(
          'questions',
          {
            'id': question.id,
            'quizId': quiz.id,
            'question_description': question.question_description,
            'options': question.options.join(','),
            'correctAnswerIndex': question.correctAnswerIndex,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      });

      // Show success snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Quiz saved to local database.'),
          backgroundColor: Colors.green.withOpacity(0.1),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      // Show error snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving quiz to local database. Please try again.'),
          backgroundColor: Colors.red.withOpacity(0.1),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _saveQuizToFirebase(BuildContext context, Quiz quiz) async {
    await _db.collection('quiz').add(quiz.toJson()).then((_) {
      AwesomeDialog(
    context: context,
    dialogType: DialogType.success, // Choose the dialog type.
    animType: AnimType.scale, // Choose an entrance animation.
    title: 'Success',
    desc: 'Quiz created successfully!',
    btnOkOnPress: () {
    },
    ).show();

      
      //  Get.snackbar('Success', 'Quiz created successfully.',
      //     snackPosition: SnackPosition.BOTTOM,
      //     backgroundColor: Colors.green.withOpacity(0.1),
      //     colorText: Colors.green);

    }).catchError((error, stackTrace) {
      Get.snackbar('Error', 'Something went wrong. Try again',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          colorText: Colors.red);
      print(error.toString());
    });

    // Show success snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Quiz saved to Firebase.'),
        backgroundColor: Colors.green.withOpacity(0.1),
        duration: Duration(seconds: 2),
      ),
    );
  }
  Future<List<Quiz>> getAllQuizzesFromSQLite() async {
  final Database db = await _databaseHelper.database;
  final List<Map<String, dynamic>> quizzesData = await db.query('quiz');
  final List<Quiz> quizzes = quizzesData.map((quizData) {
    String id = '';
    String title = '';
    quizData.forEach((key, value) {
      if (key == 'id') {
        id = value.toString();
        print(id);
      } else if (key == 'title') {
        title = value.toString();
      }

    });
   
    
    return Quiz(
      id: id,
      title: title,
      questions: [], 
    );

    
  }).toList();

  print('Fetching locally');
  return quizzes;

}

Future<void> deleteQuiz(BuildContext context, String quizId) async {
  var connectivityResult = await Connectivity().checkConnectivity();
  
  if (connectivityResult == ConnectivityResult.none) {
    // Delete quiz from Firebase since there's no internet connectivity
    await _deleteQuizFromLocalDatabase(context,quizId); 
  } else {
    // Delete quiz from local database
    await _deleteQuizFromFirebase(context,quizId);
  }
}

Future<void> _deleteQuizFromLocalDatabase(BuildContext context,String quizId) async {
  final Database db = await _databaseHelper.database;
  try {
    // Delete quiz entry
    await db.delete(
      'quiz',
      where: 'id = ?',
      whereArgs: [quizId],
    );
    
    // Delete associated questions
    await db.delete(
      'questions',
      where: 'quizId = ?',
      whereArgs: [quizId],
    );

    // Show success snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Quiz deleted from local database.'),
        backgroundColor: Colors.green.withOpacity(0.1),
        duration: Duration(seconds: 2),
      ),
    );
  } catch (e) {
    // Show error snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error deleting quiz from local database. Please try again.'),
        backgroundColor: Colors.red.withOpacity(0.1),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

Future<void> _deleteQuizFromFirebase(BuildContext context,String quizId) async {
  try {
    print(quizId);
    String id = quizId;
    await FirebaseFirestore.instance.collection('quiz').doc(id).delete();
    

    // Show success snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Quiz deleted from Firebase.'),
        backgroundColor: Colors.green.withOpacity(0.1),
        duration: Duration(seconds: 2),
      ),
    );
  } catch (e) {
    // Show error snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error deleting quiz from Firebase. Please try again.'),
        backgroundColor: Colors.red.withOpacity(0.1),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
Future<void> synchronizeDatabase(BuildContext context) async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      // No internet connection
      return;
    }

    // Get all quizzes from Firebase
    QuerySnapshot quizSnapshot = await FirebaseFirestore.instance.collection('quiz').get();
    List<Quiz> quizzesFromFirebase = quizSnapshot.docs.map((doc) {
      // Corrected code to access document data
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Quiz.fromJson(data);
    }).toList();

    List<Quiz> quizzesFromSQLite = await getAllQuizzesFromSQLite();

    // Synchronize quizzes
    for (var quiz in quizzesFromFirebase) {
      if (!quizzesFromSQLite.any((q) => q.id == quiz.id)) {
        // Quiz doesn't exist in SQLite, so add it
        await _saveQuizToLocalDatabase(context, quiz);
      }
    }

    for (var quiz in quizzesFromSQLite) {
      if (!quizzesFromFirebase.any((q) => q.id == quiz.id)) {
        // Quiz doesn't exist in Firebase, so delete it
        await _saveQuizToFirebase(context, quiz);
      }
    }
  }

}
