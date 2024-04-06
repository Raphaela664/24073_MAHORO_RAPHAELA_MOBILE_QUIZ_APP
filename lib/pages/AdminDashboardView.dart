import 'package:assignment_3/models/quiz.dart';
import 'package:assignment_3/pages/QuizCreationView.dart';
import 'package:assignment_3/repository/quiz_repository/quiz_repository.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QuizCreationView()),
              );
            },
            child: Text('Create Quiz'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QuizList()),
              );
            },
            child: Text('View Quiz List'),
          ),
          
        ],
      ),
    );
  }
}

// class QuizList extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('quiz List'),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection('quiz').snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//           final quizzes = snapshot.data!.docs;
//           return ListView.builder(
//             itemCount: quizzes.length,
//             itemBuilder: (context, index) {
//               final quiz = quizzes[index];
//               return ListTile(
//                 title: Text(quiz['title']),
//                 trailing: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     IconButton(
//                       icon: Icon(Icons.delete),
//                       onPressed: () {
//                         FirebaseFirestore.instance.collection('quiz').doc(quiz.id).delete();
//                       },
//                     ),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

class QuizList extends StatefulWidget {
  @override
  _QuizListState createState() => _QuizListState();
}

class _QuizListState extends State<QuizList> {
  final QuizRepository quizRepository = QuizRepository.instance;
  late List<Quiz> quizzes = [];

  @override
  void initState() {
    super.initState();
    _fetchQuizzes();
    quizRepository.synchronizeDatabase(context);
  }

  Future<void> _fetchQuizzes() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      // Fetch quizzes from local database
      quizzes = await quizRepository.getAllQuizzesFromSQLite();
    } else {
      // Fetch quizzes from Firebase
      quizzes = await _fetchQuizzesFromFirebase();
    }
    setState(() {}); // Update the UI after fetching quizzes
  }

  Future<List<Quiz>> _fetchQuizzesFromFirebase() async {
  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('quiz').get();
  return querySnapshot.docs.map((doc) => Quiz.fromJson(doc.data() as Map<String, dynamic>)).toList();
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz List'),
      ),
      body: quizzes.isNotEmpty
          ? ListView.builder(
              itemCount: quizzes.length,
              itemBuilder: (context, index) {
                final quiz = quizzes[index];
                return ListTile(
                  title: Text(quiz.title),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                       
                       _deleteQuiz(context,quiz.id);
                    },
                  ),
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Future<void> _deleteQuiz(BuildContext context, quizId) async {
    // Delete quiz from both local database and Firebase
    await quizRepository.deleteQuiz(context,quizId);
    _fetchQuizzes(); // Refresh quiz list
  }
}