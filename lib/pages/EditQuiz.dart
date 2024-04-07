import 'package:flutter/material.dart';
import 'package:assignment_3/models/quiz.dart';
import 'package:assignment_3/models/question.dart';

class EditQuizQuestionsPage extends StatefulWidget {
  final Quiz quiz;

  const EditQuizQuestionsPage({Key? key, required this.quiz}) : super(key: key);

  @override
  _EditQuizQuestionsPageState createState() => _EditQuizQuestionsPageState();
}

class _EditQuizQuestionsPageState extends State<EditQuizQuestionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Quiz Questions'),
      ),
      body: ListView.builder(
        itemCount: widget.quiz.questions.length,
        itemBuilder: (context, index) {
          final question = widget.quiz.questions[index];
          return ListTile(
            title: Text(question.question_description),
            subtitle: Text('Correct Answer: ${question.correct_answer_index}'),
            onTap: () {
              // Implement question editing logic here
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to a page where the admin can add a new question
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
