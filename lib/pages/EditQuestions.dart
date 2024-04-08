import 'package:assignment_3/models/quiz.dart';
import 'package:assignment_3/repository/quiz_repository/quiz_repository.dart';
import 'package:flutter/material.dart';
import 'package:assignment_3/models/question.dart';

class AddQuestionPage extends StatefulWidget {
  final Quiz quiz;
  const AddQuestionPage({Key? key, required this.quiz}) : super(key: key);
  @override
  _AddQuestionPageState createState() => _AddQuestionPageState();
}

class _AddQuestionPageState extends State<AddQuestionPage> {
  // Text editing controllers for question fields
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _option1Controller = TextEditingController();
  final TextEditingController _option2Controller = TextEditingController();
  final TextEditingController _option3Controller = TextEditingController();
  late int _correctAnswerIndex=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Question'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Question Description'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _option1Controller,
              decoration: InputDecoration(labelText: 'Option 1'),
            ),
            TextField(
              controller: _option2Controller,
              decoration: InputDecoration(labelText: 'Option 2'),
            ),
            TextField(
              controller: _option3Controller,
              decoration: InputDecoration(labelText: 'Option 3'),
            ),
            SizedBox(height: 16.0),
            Text('Select Correct Answer:'),
            RadioListTile<int>(
              title: Text('Option 1'),
              value: 0,
              groupValue: _correctAnswerIndex,
              onChanged: (int? value) {
                setState(() {
                  _correctAnswerIndex = value!;
                });
              },
            ),
            RadioListTile<int>(
              title: Text('Option 2'),
              value: 1,
              groupValue: _correctAnswerIndex,
              onChanged: (int? value) {
                setState(() {
                  _correctAnswerIndex = value!;
                });
              },
            ),
            RadioListTile<int>(
              title: Text('Option 3'),
              value: 2,
              groupValue: _correctAnswerIndex,
              onChanged: (int? value) {
                setState(() {
                  _correctAnswerIndex = value!;
                });
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _saveQuestion();
              },
              child: Text('Save Question'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveQuestion() {
    // Create a new Question object with the entered details
    final newQuestion = Question(
      id: '', 
      quiz_id: widget.quiz.id,
      question_description: _descriptionController.text,
      option1: _option1Controller.text,
      option2: _option2Controller.text,
      option3: _option3Controller.text,
      correct_answer_index: _correctAnswerIndex,
    );

    // Pass the new question back to the previous screen
    Navigator.pop(context, newQuestion);
  }

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    _descriptionController.dispose();
    _option1Controller.dispose();
    _option2Controller.dispose();
    _option3Controller.dispose();
    super.dispose();
  }
}

class EditQuestionPage extends StatefulWidget {
  final Question question;

  const EditQuestionPage({Key? key, required this.question}) : super(key: key);

  @override
  _EditQuestionPageState createState() => _EditQuestionPageState();
}

class _EditQuestionPageState extends State<EditQuestionPage> {
  late TextEditingController _descriptionController;
  late TextEditingController _option1Controller;
  late TextEditingController _option2Controller;
  late TextEditingController _option3Controller;
  late int _correctAnswerIndex;
  final QuizRepository quizRepository = QuizRepository.instance;
  
  @override
  void initState() {
    super.initState();
    // Initialize controllers with question details
    _descriptionController = TextEditingController(text: widget.question.question_description);
    _option1Controller = TextEditingController(text: widget.question.option1);
    _option2Controller = TextEditingController(text: widget.question.option2);
    _option3Controller = TextEditingController(text: widget.question.option3);
    _correctAnswerIndex = widget.question.correct_answer_index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Question'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Question Description'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _option1Controller,
              decoration: InputDecoration(labelText: 'Option 1'),
            ),
            TextField(
              controller: _option2Controller,
              decoration: InputDecoration(labelText: 'Option 2'),
            ),
            TextField(
              controller: _option3Controller,
              decoration: InputDecoration(labelText: 'Option 3'),
            ),
            SizedBox(height: 16.0),
            Text('Select Correct Answer:'),
            RadioListTile<int>(
              title: Text('Option 1'),
              value: 0,
              groupValue: _correctAnswerIndex,
              onChanged: (int? value) {
                setState(() {
                  _correctAnswerIndex = value!;
                });
              },
            ),
            RadioListTile<int>(
              title: Text('Option 2'),
              value: 1,
              groupValue: _correctAnswerIndex,
              onChanged: (int? value) {
                setState(() {
                  _correctAnswerIndex = value!;
                });
              },
            ),
            RadioListTile<int>(
              title: Text('Option 3'),
              value: 2,
              groupValue: _correctAnswerIndex,
              onChanged: (int? value) {
                setState(() {
                  _correctAnswerIndex = value!;
                });
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _saveEditedQuestion();
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveEditedQuestion() async {
    // Create a new Question object with the edited details
    final editedQuestion = Question(
      id: widget.question.id,
      quiz_id: widget.question.quiz_id ?? '',
      question_description: _descriptionController.text,
      option1: _option1Controller.text,
      option2: _option2Controller.text,
      option3: _option3Controller.text,
      correct_answer_index: _correctAnswerIndex,
    );
    await quizRepository.updateQuizQuestions(context, editedQuestion.quiz_id!, editedQuestion);

    // Pass the edited question back to the previous screen
    Navigator.pop(context, editedQuestion);
  }

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    _descriptionController.dispose();
    _option1Controller.dispose();
    _option2Controller.dispose();
    _option3Controller.dispose();
    super.dispose();
  }
}
