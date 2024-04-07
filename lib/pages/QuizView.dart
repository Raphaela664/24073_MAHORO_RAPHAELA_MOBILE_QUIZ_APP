import 'package:assignment_3/database/database_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:assignment_3/models/question.dart';
import 'package:sqflite/sqflite.dart'; // Import sqflite package

class QuizView extends StatefulWidget {
  final String quiz_id;

  const QuizView({Key? key, required this.quiz_id}) : super(key: key);

  @override
  _QuizViewState createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  late List<Question> _questions = [];
  late final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  int _currentQuestionIndex = 0;
  Map<int, int> _selectedAnswers = {};
  bool _quizStarted = false;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  void _loadQuestions() async {
    // Check internet connectivity
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      // If no internet, load questions from SQLite
      await _loadQuestionsFromSQLite();
      return;
    }

    // If internet is available, load questions from Firebase
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('questions')
        .where('quiz_id', isEqualTo: widget.quiz_id)
        .get();

    List<Question> questions = snapshot.docs.map((doc) {
      return Question.fromJson(doc.data() as Map<String, dynamic>);
    }).toList();

    setState(() {
      _questions = questions;
    });
  }

  Future<void> _loadQuestionsFromSQLite() async {
  print('Getting questions');
  final Database db = await _databaseHelper.database;

  // Query questions for the specific quiz from SQLite database
  List<Map<String, dynamic>> questionMaps = await db.query(
    'questions',
    where: 'quiz_id = ?',
    whereArgs: [widget.quiz_id],
  );

  // Convert question maps to Question objects
  List<Question> questions = questionMaps.map((questionMap) {
    return Question(
      id: questionMap['id'],
      quiz_id: questionMap['quiz_id'],
      question_description: questionMap['question_description'],
      option1: questionMap['option1'],
      option2: questionMap['option2'],
      option3: questionMap['option3'],
      correct_answer_index: questionMap['correct_answer_index'],
    );
  }).toList();

  print(questions);

  setState(() {
    _questions = questions;
  });
}




  void _startQuiz() {
    setState(() {
      _quizStarted = true;
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      _gradeQuiz();
    }
  }

  void _selectAnswer(int answerIndex) {
    setState(() {
      _selectedAnswers[_currentQuestionIndex] = answerIndex;
    });
  }

  void _gradeQuiz() {
    int score = 0;
    for (int i = 0; i < _questions.length; i++) {
      if (_selectedAnswers.containsKey(i) &&
          _selectedAnswers[i] == _questions[i].correct_answer_index) {
        score++;
      }
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Quiz Completed'),
        content: Text('Your score: $score / ${_questions.length}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_quizStarted) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Quiz'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: _startQuiz,
            child: Text('Start Quiz'),
          ),
        ),
      );
    }

    if (_questions == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Quiz'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Quiz'),
        ),
        body: Center(
          child: Text('No questions available for this quiz.'),
        ),
      );
    }

    Question currentQuestion = _questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question ${_currentQuestionIndex + 1}/${_questions.length}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              currentQuestion.question_description,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: List.generate(currentQuestion.options.length, (index) {
            //     return RadioListTile<int>(
            //       title: Text(currentQuestion.options[index]),
            //       value: index,
            //       groupValue: _selectedAnswers.containsKey(_currentQuestionIndex)
            //           ? _selectedAnswers[_currentQuestionIndex]
            //           : null,
            //       onChanged: (value) {
            //         _selectAnswer(value!);
            //       },
            //     );
            //   }),
            // ),
            RadioListTile<int>(
  title: Text(currentQuestion.option1),
  value: 0,
  groupValue: _selectedAnswers.containsKey(_currentQuestionIndex)
      ? _selectedAnswers[_currentQuestionIndex]
      : null,
  onChanged: (value) {
    _selectAnswer(value!);
  },
),
RadioListTile<int>(
  title: Text(currentQuestion.option2),
  value: 1,
  groupValue: _selectedAnswers.containsKey(_currentQuestionIndex)
      ? _selectedAnswers[_currentQuestionIndex]
      : null,
  onChanged: (value) {
    _selectAnswer(value!);
  },
),
RadioListTile<int>(
  title: Text(currentQuestion.option3),
  value: 2,
  groupValue: _selectedAnswers.containsKey(_currentQuestionIndex)
      ? _selectedAnswers[_currentQuestionIndex]
      : null,
  onChanged: (value) {
    _selectAnswer(value!);
  },
),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _selectedAnswers.containsKey(_currentQuestionIndex)
                  ? _nextQuestion
                  : null,
              child: Text(_currentQuestionIndex == _questions.length - 1
                  ? 'Finish Quiz'
                  : 'Next Question'),
            ),
          ],
        ),
      ),
    );
  }
}

