import 'package:assignment_3/controllers/quiz_controller.dart';
import 'package:assignment_3/models/question.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuizCreationView extends StatefulWidget {
  
  const QuizCreationView({Key? key}) : super(key: key);

  @override
  _QuizCreationViewState createState() => _QuizCreationViewState();
}

class _QuizCreationViewState extends State<QuizCreationView> {
  List<Question> _questions = [];
  final QuizController _quizController = Get.put(QuizController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Quiz'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: _addQuestion,
              child: Text('Add Question'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _questions.length,
                itemBuilder: (context, index) {
                  return _buildQuestionCard(_questions[index], index);
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveQuiz,
              child: Text('Save Quiz'),
            ),
          ],
        ),
      ),
    );
  }

  void _addQuestion() {
    setState(() {
      _questions.add(Question(
        question_description: '',
        options: ['', '', ''],
        correctAnswerIndex: 0,
      ));
    });
  }

  Widget _buildQuestionCard(Question question, int index) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question ${index + 1}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(labelText: 'Question'),
              onChanged: (value) => question.question_description = value,
            ),
            SizedBox(height: 10),
            _buildOptionTextField(question.options[0], 'Option A', (newValue) {
              setState(() {
                question.options[0] = newValue;
              });
            }),
            _buildOptionTextField(question.options[1], 'Option B', (newValue) {
              setState(() {
                question.options[1] = newValue;
              });
            }),
            _buildOptionTextField(question.options[2], 'Option C', (newValue) {
              setState(() {
                question.options[2] = newValue;
              });
            }),
            SizedBox(height: 10),
            DropdownButtonFormField(
              value: question.correctAnswerIndex.toString(),
              onChanged: (value) {
                setState(() {
                  question.correctAnswerIndex = int.parse(value!);
                });
              },
              items: List.generate(
                question.options.length,
                (index) => DropdownMenuItem(
                  value: index.toString(),
                  child: Text('Option ${String.fromCharCode(65 + index)}'),
                ),
              ),
              decoration: InputDecoration(labelText: 'Correct Answer'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTextField(String value, String label, ValueChanged<String> onChanged) {
    return TextField(
      decoration: InputDecoration(labelText: label),
      onChanged: onChanged,
    );
  }

  void _saveQuiz() {
    _quizController.saveQuiz(_questions);
  }
}

// import 'package:assignment_3/models/question.dart';
// import 'package:flutter/material.dart';
// import 'package:assignment_3/controllers/quiz_controller.dart';
// import 'package:get/get.dart'; // Import your QuizController

// class QuizCreationView extends StatefulWidget {
//   const QuizCreationView({Key? key}) : super(key: key);

//   @override
//   _QuizCreationViewState createState() => _QuizCreationViewState();
// }

// class _QuizCreationViewState extends State<QuizCreationView> {
//   // final QuizController _quizController = QuizController.instance; // Accessing QuizController instance

// final QuizController _quizController = Get.put(QuizController());

//   List<Question> _questions = [];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Create Quiz'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ElevatedButton(
//               onPressed: _addQuestion,
//               child: Text('Add Question'),
//             ),
//             SizedBox(height: 20),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: _questions.length,
//                 itemBuilder: (context, index) {
//                   return _buildQuestionCard(_questions[index], index);
//                 },
//               ),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _saveQuiz,
//               child: Text('Save Quiz'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _addQuestion() {
//     setState(() {
//       _questions.add(Question(
//         question_description: '',
//         options: ['', '', ''],
//         correctAnswerIndex: 0,
//       ));
//     });
//   }

//   Widget _buildQuestionCard(Question question, int index) {
//     return Card(
//       margin: EdgeInsets.symmetric(vertical: 10),
//       child: Padding(
//         padding: EdgeInsets.all(10),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Question ${index + 1}',
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 10),
//           ],
//         ),
//       ),
//     );
//   }

//   void _saveQuiz() {
//     _quizController.saveQuiz(_questions); 
//   }
// }
