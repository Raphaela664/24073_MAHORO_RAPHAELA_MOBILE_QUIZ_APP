import 'package:assignment_3/models/quiz.dart';
import 'package:assignment_3/pages/QuizCreationView.dart';
import 'package:assignment_3/pages/ResultsAdminDashboard.dart';
import 'package:assignment_3/pages/SingleQuizView.dart';
import 'package:assignment_3/repository/quiz_repository/quiz_repository.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// class AdminDashboard extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ListView(
//         padding: EdgeInsets.all(20),
//         children: [
//           ElevatedButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => QuizCreationView()),
//               );
//             },
//             child: Text('Create Quiz'),
//           ),
//           SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => QuizList()),
//               );
//             },
//             child: Text('View Quiz List'),
//           ),
//           SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => ResultsPage()),
//               );
//             },
//             child: Text('View Results'),
//           ),
          
//         ],
//       ),
//     );
//   }
// }
class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Image.asset(
            'images/online-quiz.gif', // Replace 'your_image.png' with your image asset path
            height: 150, // Adjust the height as needed
            width: 150, // Adjust the width as needed
          ),
          SizedBox(height: 20),
          ListView(
            padding: EdgeInsets.all(20),
            shrinkWrap: true,
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ResultsPage()),
                  );
                },
                child: Text('View Results'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class QuizList extends StatefulWidget {
  @override
  _QuizListState createState() => _QuizListState();
}

class _QuizListState extends State<QuizList> {
  final QuizRepository quizRepository = QuizRepository.instance;
  late List<Quiz> quizzes = [];
  bool isLoading = true; // Add isLoading state

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
    setState(() {
      isLoading = false; // Set isLoading to false after fetching quizzes
    });
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
      body: isLoading // Check if isLoading is true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : quizzes.isNotEmpty
              ? ListView.builder(
                  itemCount: quizzes.length,
                  itemBuilder: (context, index) {
                    final quiz = quizzes[index];
                    return ListTile(
                      title: Text(quiz.title),
                      onTap: () {
                        // Navigate to SingleQuizView when a quiz is clicked
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SingleQuizView(quiz: quiz),
                          ),
                        );
                      },
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _deleteQuiz(context, quiz);
                        },
                      ),
                    );
                  },
                )
              : Center(
                  child: Text('No quizzes available.'),
                ),
    );
  }

  Future<void> _deleteQuiz(BuildContext context, Quiz quiz) async {
    // Show a dialog to confirm deletion
    bool confirmDeletion = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Deletion"),
          content: Text("Are you sure you want to delete this quiz?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Return false when cancel button is pressed
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Return true when delete button is pressed
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );

    // If user confirms deletion, proceed with deletion
    if (confirmDeletion) {
      // Delete quiz from both local database and Firebase
      await quizRepository.deleteQuiz(context, quiz.id);
      _fetchQuizzes(); // Refresh quiz list
    }
  }
}
