import 'package:flutter/material.dart';

class QuizCreationView extends StatefulWidget {
  @override
  _QuizCreationViewState createState() => _QuizCreationViewState();
}

class _QuizCreationViewState extends State<QuizCreationView> {
  List<Question> _questions = [];

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
      _questions.add(Question());
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
              onChanged: (value) => question.question = value,
            ),
            SizedBox(height: 10),
            _buildOptionTextField(question.options[0], 'Option A'),
            _buildOptionTextField(question.options[1], 'Option B'),
            _buildOptionTextField(question.options[2], 'Option C'),
            SizedBox(height: 10),
            DropdownButtonFormField(
              value: question.correctAnswer,
              onChanged: (value) => question.correctAnswer = value as String?,
              items: ['Option A', 'Option B', 'Option C']
                  .map<DropdownMenuItem<String>>((option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
              decoration: InputDecoration(labelText: 'Correct Answer'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTextField(String value, String label) {
    return TextField(
      decoration: InputDecoration(labelText: label),
      onChanged: (newValue) => value = newValue,
    );
  }

  void _saveQuiz() {
    // Save quiz logic
    print('Saved Questions:');
    for (int i = 0; i < _questions.length; i++) {
      print('Question ${i + 1}: ${_questions[i].question}');
      print('Options: ${_questions[i].options}');
      print('Correct Answer: ${_questions[i].correctAnswer}');
    }
  }
}

class Question {
  String question = '';
  List<String> options = ['', '', ''];
  String? correctAnswer;
}
