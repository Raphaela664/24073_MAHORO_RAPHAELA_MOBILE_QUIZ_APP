import 'package:assignment_3/database/database_service.dart';
import 'package:assignment_3/models/question.dart';
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
  bool _syncing = false;

  

  Future<void> createQuiz(BuildContext context, Quiz quiz) async {
    // Check connectivity status
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult != ConnectivityResult.none) {
      // If internet connection is available, save to Firebase
      await _saveQuizToFirebase(context, quiz);
    }
      await _saveQuizToLocalDatabase(context, quiz);

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
            'quiz_id': quiz.id,
            'question_description': question.question_description,
            'option1': question.option1,
            'option2': question.option2,
            'option3': question.option3,
            'correct_answer_index': question.correct_answer_index,
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
      
//

    }).catchError((error, stackTrace) {
      Get.snackbar('Error', 'Something went wrong. Try again',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          colorText: Colors.red);
      print(error.toString());
    });
    if(!_syncing){
    // Show success snackbar
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text('Quiz saved to Firebase.'),
    //     backgroundColor: Colors.green.withOpacity(0.1),
    //     duration: Duration(seconds: 2),
    //   ),
    // );
    AwesomeDialog(
    context: context,
    dialogType: DialogType.success, // Choose the dialog type.
    animType: AnimType.scale, // Choose an entrance animation.
    title: 'Success',
    desc: 'Quiz created successfully!',
    btnOkOnPress: () {
    },
    ).show();
    }
  }

  Future<List<Quiz>> getAllQuizzesFromSQLite() async {
  final Database db = await _databaseHelper.database;
  final List<Map<String, dynamic>> quizzesData = await db.query('quiz');

  // Iterate through each quiz data and fetch questions for each quiz
  final List<Quiz> quizzes = await Future.wait(quizzesData.map((quizData) async {
    String id = '';
    String title = '';
    List<Question> questions = [];

    // Extract quiz id and title
    quizData.forEach((key, value) {
      if (key == 'id') {
        id = value.toString();
      } else if (key == 'title') {
        title = value.toString();
      }
    });

    // Fetch questions for the current quiz
    final List<Map<String, dynamic>> questionsData = await db.query('questions', where: 'quiz_id = ?', whereArgs: [id]);
    questions = questionsData.map((questionData) {
      return Question.fromJson(questionData);
    }).toList();

    return Quiz(
      id: id,
      title: title,
      questions: questions,
    );
  }).toList());

  print('Fetching quizzes and questions locally');
  return quizzes;
}


Future<void> deleteQuiz(BuildContext context, String quizId) async {
  var connectivityResult = await Connectivity().checkConnectivity();
  
  if (connectivityResult != ConnectivityResult.none) {
    // Delete quiz from local database
    await _deleteQuizFromFirebase(context,quizId);
  }
  await _deleteQuizFromLocalDatabase(context,quizId); 
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
      where: 'quiz_id = ?',
      whereArgs: [quizId],
    );
    if(!_syncing){
    // Show success snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Quiz deleted from local database.'),
        backgroundColor: Colors.green.withOpacity(0.1),
        duration: Duration(seconds: 2),
      ),
    );
    }
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

Future<void> _deleteQuizFromFirebase(BuildContext context, String quizId) async {
  try {
    // Query the Firestore collection to find the document with the matching id field
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('quiz').where('id', isEqualTo: quizId).get();

    // Check if any documents match the query
    if (querySnapshot.docs.isNotEmpty) {
      // If a document is found, delete it
      await querySnapshot.docs.first.reference.delete();
      if(!_syncing){
         ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Quiz deleted from Firebase.'),
          backgroundColor: Colors.green.withOpacity(0.1),
          duration: Duration(seconds: 2),
        ),
      );
      }
      // Show success snackbar
     
    } else {
      // Show error snackbar if no matching document is found
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Quiz with ID $quizId not found in Firebase.'),
          backgroundColor: Colors.red.withOpacity(0.1),
          duration: Duration(seconds: 2),
        ),
      );
    }
  } catch (e) {
    // Show error snackbar if an exception occurs
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
    _syncing = true;
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
        // Quiz doesn't exist in SQLite, so delete it from firebase
        await _deleteQuizFromFirebase(context, quiz.id);
      }
    }

    for (var quiz in quizzesFromSQLite) {
      if (!quizzesFromFirebase.any((q) => q.id == quiz.id)) {
        // Quiz exist locally but not in firebase, so add it to firebase
        await _saveQuizToFirebase(context, quiz);
      }
    }
    _syncing=false;
  }

  Future<void> _updateQuizQuestionsLocally(String quizId, Question updatedQuestion) async {
  final Database db = await _databaseHelper.database;
  try {
    await db.transaction((txn) async {
      // Delete existing questions for the given quiz ID
      await txn.delete('questions', where: 'id = ?', whereArgs: [updatedQuestion.id]);

      // Insert updated questions
      
        await txn.insert('questions', {
          'id': updatedQuestion.id,
          'quiz_id': quizId,
          'question_description': updatedQuestion.question_description,
          'option1': updatedQuestion.option1,
          'option2': updatedQuestion.option2,
          'option3': updatedQuestion.option3,
          'correct_answer_index': updatedQuestion.correct_answer_index,
        });
      
    });
    print('Question updated locally');
  } catch (e) {
    // Handle any errors
    print('Error updating questions locally: $e');
    rethrow; // Rethrow the exception for the calling method to handle
  }
}

Future<void> _updateQuizQuestionsInFirebase(String quizId, Question updatedQuestion) async {
  try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('quiz').where('id', isEqualTo: quizId).get();
    

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot quizSnapshot = querySnapshot.docs.first;
      // Convert the document data to a Map
      Map<String, dynamic>? quizData = quizSnapshot.data() as Map<String, dynamic>?;

      if (quizData != null) {
        List<dynamic> questions = quizData['questions'] ?? [];

        // Find the index of the updated question in the questions array
        int index = questions.indexWhere((question) => question['id'] == updatedQuestion.id);

        // Update the question at the found index with the updated question data
        if (index != -1) {
          questions[index] = updatedQuestion.toJson();

          // Update the questions array in the quiz document
          await quizSnapshot.reference.update({'questions': questions});

          print('Question updated in Firebase');
        } else {
          print('Question with ID ${updatedQuestion.id} not found in the quiz $quizId');
        }
      }
    } else {
      print('Quiz with ID $quizId not found in Firebase');
    }
  } catch (e) {
    // Handle any errors
    print('Error updating question in Firebase: $e');
    rethrow; // Rethrow the exception for the calling method to handle
  }
}



Future<void> updateQuizQuestions(BuildContext context, String quizId, Question updatedQuestions) async {
  var connectivityResult = await Connectivity().checkConnectivity();
  
  if (connectivityResult != ConnectivityResult.none) {
    await _updateQuizQuestionsInFirebase(quizId, updatedQuestions); 
  }
    await _updateQuizQuestionsLocally( quizId, updatedQuestions);

  AwesomeDialog(
    context: context,
    dialogType: DialogType.success, 
    animType: AnimType.scale,
    title: 'Success',
    desc: 'Quiz Updated successfully!',
    btnOkOnPress: () {
    },
    ).show();
}

Future<void> createQuestion(BuildContext context, Question question) async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult != ConnectivityResult.none) {
      await _saveQuestionToFirebase(context, question);
    }

    await _saveQuestionToLocalDatabase(context, question);
  }

  Future<void> _saveQuestionToLocalDatabase(BuildContext context, Question question) async {
    final Database db = await _databaseHelper.database;
    try {
      await db.insert(
        'questions',
        {
          'id': question.id,
          'quiz_id': question.quiz_id,
          'question_description': question.question_description,
          'option1': question.option1,
          'option2': question.option2,
          'option3': question.option3,
          'correct_answer_index': question.correct_answer_index,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      if(!_syncing){
        AwesomeDialog(
    context: context,
    dialogType: DialogType.success, // Choose the dialog type.
    animType: AnimType.scale, // Choose an entrance animation.
    title: 'Success',
    desc: 'Quiz created successfully!',
    btnOkOnPress: () {
    },
    ).show();
      }
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving question to local database. Please try again.'),
          backgroundColor: Colors.red.withOpacity(0.1),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
  
Future<void> _saveQuestionToFirebase(BuildContext context, Question question) async {
  try {
    // Retrieve the quiz document that matches the provided quizId
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('quiz').where('id', isEqualTo: question.quiz_id).get();
    
    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot quizSnapshot = querySnapshot.docs.first;
      // Convert the document data to a Map
      Map<String, dynamic>? quizData = quizSnapshot.data() as Map<String, dynamic>?;

      if (quizData != null) {
        List<dynamic> questions = quizData['questions'] ?? [];

        // Add the newly created question to the questions array
        await _db.collection('questions').add(question.toJson());
        questions.add(question.toJson());

        // Update the questions array in the quiz document
        
        await quizSnapshot.reference.update({'questions': questions});

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Question saved to Firebase and linked with the quiz.'),
            backgroundColor: Colors.green.withOpacity(0.1),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add question: Quiz data not found.'),
            backgroundColor: Colors.red.withOpacity(0.1),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add question: Quiz not found.'),
          backgroundColor: Colors.red.withOpacity(0.1),
          duration: Duration(seconds: 2),
        ),
      );
    }
  } catch (e) {
    print(e);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error saving question to Firebase. Please try again.'),
        backgroundColor: Colors.red.withOpacity(0.1),
        duration: Duration(seconds: 2),
      ),
    );
  }
}




}
