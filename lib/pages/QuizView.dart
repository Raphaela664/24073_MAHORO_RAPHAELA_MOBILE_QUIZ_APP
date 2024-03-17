// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:assignment_3/models/question.dart';

// class QuizView extends StatefulWidget {
//   final String quizId;

//   const QuizView({Key? key, required this.quizId}) : super(key: key);

//   @override
//   _QuizViewState createState() => _QuizViewState();
// }

// class _QuizViewState extends State<QuizView> {
//   late List<Question> _questions;
//   int _currentQuestionIndex = 0;
//   Map<int, int> _selectedAnswers = {};

//   @override
//   void initState() {
//     super.initState();
//     _loadQuestions();
//   }

//   void _loadQuestions() async {
//   QuerySnapshot snapshot = await FirebaseFirestore.instance
//       .collection('Questions')
//       .where('quizId', isEqualTo: widget.quizId)
//       .get();

//   List<Question> questions = snapshot.docs.map((doc) {
//     // Explicitly cast the result of doc.data() to Map<String, dynamic>
//     return Question.fromJson(doc.data() as Map<String, dynamic>);
//   }).toList();

//   setState(() {
//     _questions = questions;
//   });
// }

//   void _nextQuestion() {
//     if (_currentQuestionIndex < _questions.length - 1) {
//       setState(() {
//         _currentQuestionIndex++;
//       });
//     } else {
//       _gradeQuiz();
//     }
//   }

//   void _selectAnswer(int answerIndex) {
//     setState(() {
//       _selectedAnswers[_currentQuestionIndex] = answerIndex;
//     });
//   }

//   void _gradeQuiz() {
//     // Calculate score based on correct answers
//     int score = 0;
//     for (int i = 0; i < _questions.length; i++) {
//       if (_selectedAnswers.containsKey(i) &&
//           _selectedAnswers[i] == _questions[i].correctAnswerIndex) {
//         score++;
//       }
//     }

//     // Provide feedback to the user
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Quiz Completed'),
//         content: Text('Your score: $score / ${_questions.length}'),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             child: Text('Close'),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_questions == null) {
//       return Center(child: CircularProgressIndicator());
//     }

//     if (_questions.isEmpty) {
//       return Center(child: Text('No questions available for this quiz.'));
//     }

//     Question currentQuestion = _questions[_currentQuestionIndex];

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Quiz'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Question ${_currentQuestionIndex + 1}/${_questions.length}',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 10),
//             Text(
//               currentQuestion.question_description,
//               style: TextStyle(fontSize: 20),
//             ),
//             SizedBox(height: 20),
//             // Display options for the current question
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: List.generate(currentQuestion.options.length, (index) {
//                 return RadioListTile<int>(
//                   title: Text(currentQuestion.options[index]),
//                   value: index,
//                   groupValue: _selectedAnswers.containsKey(_currentQuestionIndex)
//                       ? _selectedAnswers[_currentQuestionIndex]
//                       : null,
//                   onChanged: (value) {
//                     _selectAnswer(value!);
//                   },
//                 );
//               }),
//             ),
//             SizedBox(height: 20),
//             // Next button
//             ElevatedButton(
//               onPressed: _selectedAnswers.containsKey(_currentQuestionIndex)
//                   ? _nextQuestion
//                   : null,
//               child: Text(_currentQuestionIndex == _questions.length - 1
//                   ? 'Finish Quiz'
//                   : 'Next Question'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:assignment_3/models/question.dart';

class QuizView extends StatefulWidget {
  final String quizId;

  const QuizView({Key? key, required this.quizId}) : super(key: key);

  @override
  _QuizViewState createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  late List<Question> _questions;
  int _currentQuestionIndex = 0;
  Map<int, int> _selectedAnswers = {};
  bool _quizStarted = false;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  void _loadQuestions() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Questions')
        .where('quizId', isEqualTo: widget.quizId)
        .get();

    List<Question> questions = snapshot.docs.map((doc) {
      return Question.fromJson(doc.data() as Map<String, dynamic>);
    }).toList();

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
          _selectedAnswers[i] == _questions[i].correctAnswerIndex) {
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(currentQuestion.options.length, (index) {
                return RadioListTile<int>(
                  title: Text(currentQuestion.options[index]),
                  value: index,
                  groupValue: _selectedAnswers.containsKey(_currentQuestionIndex)
                      ? _selectedAnswers[_currentQuestionIndex]
                      : null,
                  onChanged: (value) {
                    _selectAnswer(value!);
                  },
                );
              }),
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

