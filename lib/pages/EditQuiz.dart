import 'package:assignment_3/pages/EditQuestions.dart';
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
  // Variable to store the edited questions
  late List<Question> editedQuestions;
  late Quiz quiz;
  

  @override
  void initState() {
    super.initState();
    // Initialize editedQuestions with the questions from the original quiz
    editedQuestions = List<Question>.from(widget.quiz.questions);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Quiz Questions'),
      ),
      body: ListView.builder(
        itemCount: editedQuestions.length,
        itemBuilder: (context, index) {
          final question = editedQuestions[index];
          return ListTile(
            title: Text(question.question_description),
            subtitle: Text('Correct Answer: ${question.correct_answer_index}'),
            onTap: () {
              // Implement question editing logic here
              _editQuestion(context, index);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to a page where the admin can add a new question
          _addQuestion(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // Function to edit a question
  void _editQuestion(BuildContext context, int index) async {
    // Navigate to a page where the admin can edit the question
    final editedQuestion = await Navigator.push<Question>(
      context,
      MaterialPageRoute(
        builder: (context) => EditQuestionPage(question: editedQuestions[index]),
      ),
    );

    // Update the edited question if it's not null
    if (editedQuestion != null) {
      setState(() {
        editedQuestions[index] = editedQuestion;
      });
    }
  }

  // Function to add a new question
  void _addQuestion(BuildContext context) async {
    // Navigate to a page where the admin can add a new question
    final newQuestion = await Navigator.push<Question>(
      context,
      MaterialPageRoute(
        
        builder: (context) => AddQuestionPage(quiz: widget.quiz),
      ),
    );

    // Add the new question if it's not null
    if (newQuestion != null) {
      setState(() {
        editedQuestions.add(newQuestion);
      });
    }
  }
}

// You need to implement EditQuestionPage and AddQuestionPage for editing and adding questions respectively.

