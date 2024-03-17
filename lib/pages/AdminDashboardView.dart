// import 'package:assignment_3/pages/QuizCreationView.dart';
// import 'package:flutter/material.dart';

// class AdminDashboard extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Admin Dashboard'),
//       ),
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
//           ElevatedButton(
//             onPressed: () {
              
//             },
//             child: Text('View Quiz List'),
//           ),
//           SizedBox(height: 20),
//           SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: () {
//               // Navigate to quiz results page
//             },
//             child: Text('View Quiz Results'),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class QuizList extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Quiz List'),
//       ),
//       body: ListView.builder(
//         itemCount: 5, // Example, replace with actual quiz count
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text('Quiz ${index + 1}'),
//             trailing: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 IconButton(
//                   icon: Icon(Icons.edit),
//                   onPressed: () {
//                     // Navigate to update quiz page
//                   },
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.delete),
//                   onPressed: () {
//                     // Delete quiz logic
//                   },
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class QuizResults extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Quiz Results'),
//       ),
//       body: Center(
//         child: Text('Table of Quiz Results'),
//       ),
//     );
//   }
// }


import 'package:assignment_3/pages/QuizCreationView.dart';
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
              // Navigate to quiz results page
            },
            child: Text('View Quiz Results'),
          ),
        ],
      ),
    );
  }
}

class QuizList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Quiz').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final quizzes = snapshot.data!.docs;
          return ListView.builder(
            itemCount: quizzes.length,
            itemBuilder: (context, index) {
              final quiz = quizzes[index];
              return ListTile(
                title: Text(quiz['title']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        // Navigate to update quiz page
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        // Delete quiz logic
                        FirebaseFirestore.instance.collection('Quiz').doc(quiz.id).delete();
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
