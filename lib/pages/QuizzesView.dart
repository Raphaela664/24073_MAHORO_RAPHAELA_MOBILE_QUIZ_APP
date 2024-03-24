import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:assignment_3/pages/QuizView.dart';
import 'package:assignment_3/models/quiz.dart';
import 'package:assignment_3/repository/quiz_repository/quiz_repository.dart';

class QuizzesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50),
            Image.asset(
              'images/quiz1.jpeg',
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 30),
            Text(
              "Quizzes Available",
              style: TextStyle(fontSize: 23.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            Expanded(
              child: FutureBuilder(
                future: _checkConnection(), // Check for internet connection
                builder: (context, AsyncSnapshot<bool> connectionSnapshot) {
                  if (connectionSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (connectionSnapshot.hasError) {
                    return Center(child: Text('Error: ${connectionSnapshot.error}'));
                  } else if (!connectionSnapshot.data!) {
                    // No internet connection
                    return _buildQuizzesListFromSQLite();
                  } else {
                    // Internet connection available, fetch quizzes from Firestore
                    return StreamBuilder(
                      stream: FirebaseFirestore.instance.collection('quiz').snapshots(),
                      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else {
                          return _buildQuizzesListFromFirestore(context, snapshot);
                        }
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _checkConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi;
  }

  Widget _buildQuizzesListFromFirestore(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    return ListView(
      children: snapshot.data!.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        return _buildQuizCard(context, data['title'], data['id']);
      }).toList(),
    );
  }

  Widget _buildQuizzesListFromSQLite() {
    return FutureBuilder(
      future: QuizRepository.instance.getAllQuizzesFromSQLite(),
      builder: (context, AsyncSnapshot<List<Quiz>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.data == null || snapshot.data!.isEmpty) {
          return Center(child: Text('No quizzes available'));
        } else {
          // Display quizzes fetched from SQLite
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Quiz quiz = snapshot.data![index];
              return _buildQuizCard(context, quiz.title, quiz.id!);
            },
          );
        }
      },
    );
  }

  Widget _buildQuizCard(BuildContext context, String quizTitle, String quizId) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizView(quizId: quizId),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              quizTitle,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(Icons.arrow_forward),
          ],
        ),
      ),
    );
  }
}
