import 'package:assignment_3/controllers/quiz_controller.dart';
import 'package:assignment_3/models/question.dart';
import 'package:assignment_3/models/quiz.dart';
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
  TextEditingController _quizTitleController = TextEditingController();

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
            TextField(
              controller: _quizTitleController,
              decoration: InputDecoration(labelText: 'Quiz Title'),
            ),
            SizedBox(height: 20),
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
        option1:'',
        option2:'',
        option3:'',
        correct_answer_index: 0,
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
            _buildOptionTextField(
              question.option1,
              'Option A',
              (newValue) {
                setState(() {
                  question.option1 = newValue;
                });
              },
            ),
            _buildOptionTextField(
              question.option2,
              'Option B',
              (newValue) {
                setState(() {
                  question.option2 = newValue;
                });
              },
            ),
            _buildOptionTextField(
              question.option3,
              'Option C',
              (newValue) {
                setState(() {
                  question.option3 = newValue;
                });
              },
            ),
            SizedBox(height: 10),
            DropdownButtonFormField(
              value: question.correct_answer_index.toString(),
              onChanged: (value) {
                setState(() {
                  question.correct_answer_index = int.parse(value!);
                });
              },
              items: List.generate(
                3,
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
  void _saveQuiz() async{
  String quizTitle = _quizTitleController.text;
  Quiz quiz = Quiz(
    id:'',
    title: quizTitle,
    questions: _questions,
  );
  await _quizController.saveQuizWithQuestions(context, quiz);
 // await Future.delayed(Duration(seconds: 2));

  // Clear fields after saving the quiz
  setState(() {
    _questions.clear();
    _quizTitleController.clear();
  });
}


  // void _saveQuiz() {
  //   String quizTitle = _quizTitleController.text;
  //   Quiz quiz = Quiz(
  //     id:'',
  //     title: quizTitle,
  //     questions: _questions,
  //   );
  //   _quizController.saveQuizWithQuestions(context,quiz);
  // }
}

