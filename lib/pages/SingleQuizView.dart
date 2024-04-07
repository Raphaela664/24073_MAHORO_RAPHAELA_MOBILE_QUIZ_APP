// import 'package:flutter/material.dart';
// import 'package:assignment_3/models/quiz.dart';

// class SingleQuizView extends StatelessWidget {
//   final Quiz quiz;

//   const SingleQuizView({Key? key, required this.quiz}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Quiz Details'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Text(
//               'Quiz Title: ${quiz.title}',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 20),
//             // Display other details of the quiz here
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:assignment_3/pages/EditQuiz.dart';
import 'package:flutter/material.dart';
import 'package:assignment_3/models/quiz.dart';
import 'package:assignment_3/models/question.dart';

class SingleQuizView extends StatelessWidget {
  final Quiz quiz;

  const SingleQuizView({Key? key, required this.quiz}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Details'),
        actions: [
          IconButton(
            onPressed: () {
              // Navigate to the QuizQuestionList when the admin icon is clicked
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditQuizQuestionsPage(quiz: quiz),
                ),
              );
            },
            icon: Icon(Icons.edit), // You can change the icon as needed
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quiz Title: ${quiz.title}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Quiz Questions:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _buildQuestionWidgets(),
            ),
            // Display other details of the quiz here
          ],
        ),
      ),
    );
  }

  List<Widget> _buildQuestionWidgets() {
    List<Widget> questionWidgets = [];
    for (int i = 0; i < quiz.questions.length; i++) {
      Question question = quiz.questions[i];
      questionWidgets.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question ${i + 1}: ${question.question_description}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text('Options:'),
            Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('- ${question.option1}'),
              Text('- ${question.option2}'),
              Text('- ${question.option3}'),
            ],
          ),
            SizedBox(height: 10),
          ],
        ),
      );
    }
    return questionWidgets;
  }
}

