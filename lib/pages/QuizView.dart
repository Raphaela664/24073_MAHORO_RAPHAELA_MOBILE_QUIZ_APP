// import 'package:flutter/material.dart';

// class QuizView extends StatefulWidget {
//   const QuizView({super.key});

//   @override
//   State<QuizView> createState() => _QuizViewState();
// }

// class _QuizViewState extends State<QuizView> {
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuizView extends StatelessWidget {
  final String quizId;

  const QuizView({Key? key, required this.quizId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Quiz').doc(quizId).snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            Map<String, dynamic>? data = snapshot.data?.data() as Map<String, dynamic>?;

            if (data == null) {
              return Center(child: Text('Quiz not found'));
            }

            String quizTitle = data['title'];
            // You can access other quiz data here

            return Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quiz Title: $quizTitle',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  // You can display other quiz information here
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
