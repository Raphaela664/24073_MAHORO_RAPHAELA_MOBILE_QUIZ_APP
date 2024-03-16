// import 'package:flutter/material.dart';

// class QuizzesView extends StatefulWidget {
//   const QuizzesView({super.key});

//   @override
//   State<QuizzesView> createState() => _QuizzesViewState();
// }

// class _QuizzesViewState extends State<QuizzesView> {
//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//       body: Container(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [

//             Stack(
//               children: [ Container(
//                 height: 220,
//                 padding: EdgeInsets.all(25),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   backgroundBlendMode: BlendMode.multiply,
//                   borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))
//                 ),
//                 child: Row(
//                   children: [
                  
                    
//                   ],
//                 ),
//               ),
//               Container(
//   width: MediaQuery.of(context).size.width,
//   decoration: BoxDecoration(
//     borderRadius: BorderRadius.circular(30),
//     image: DecorationImage(
//       image: AssetImage('images/quiz1.jpeg'),
//       fit: BoxFit.fill,
//     ),
//   ),
//   margin: EdgeInsets.only(top: 80.0, left: 20.0, right:20.0),
//   child: Row(
//     children: [
//       // You can add child widgets inside the container if needed
//     ],
//   ),
// )


//               ]
//             ),
//             SizedBox(height: 30.0),
//             Padding(
//               padding: const EdgeInsets.only(left: 20.0),
//               child: Text("QUizes Available",style: TextStyle(fontSize: 23.0, fontWeight: FontWeight.bold),),
//             ),
//             Row(children: [
              
//             ],)
//           ]
//         ),
//       ),
//     );
//   }
// }





// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:assignment_3/pages/QuizView.dart';

// class QuizzesView extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Background image
//           Container(
//             height: MediaQuery.of(context).size.height,
//             width: double.infinity,
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage('images/quiz1.jpeg'), // Replace with your image asset
//                 fit: BoxFit.fill,
//               ),
//             ),
//           ),
//           // Content
//           Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(height: 100), // Spacer for the image
//                 Text(
//                   "Quizzes Available",
//                   style: TextStyle(fontSize: 23.0, fontWeight: FontWeight.bold, color: Colors.white),
//                 ),
//                 SizedBox(height: 30),
//                 // Quiz list
//                 Expanded(
//                   child: StreamBuilder(
//                     stream: FirebaseFirestore.instance.collection('Quiz').snapshots(),
//                     builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return Center(child: CircularProgressIndicator());
//                       } else if (snapshot.hasError) {
//                         return Center(child: Text('Error: ${snapshot.error}'));
//                       } else {
//                         return ListView(
//                           children: snapshot.data!.docs.map((DocumentSnapshot document) {
//                             Map<String, dynamic> data = document.data() as Map<String, dynamic>;
//                             return _buildQuizCard(context, data['title'], document.id);
//                           }).toList(),
//                         );
//                       }
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildQuizCard(BuildContext context, String quizTitle, String quizId) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => QuizView(quizId: quizId),
//           ),
//         );
//       },
//       child: Container(
//         margin: EdgeInsets.only(bottom: 20),
//         padding: EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color: Colors.white.withOpacity(0.7),
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.5),
//               spreadRadius: 1,
//               blurRadius: 5,
//               offset: Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               quizTitle,
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Icon(Icons.arrow_forward),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:assignment_3/pages/QuizView.dart';

class QuizzesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 100), // Spacer for the image
            Image.asset(
              'images/quiz1.jpeg', // Replace with your image asset
              height: 200, // Adjust height as needed
              width: double.infinity, // Take full width
              fit: BoxFit.cover, // Cover the entire space
            ),
            SizedBox(height: 30),
            Text(
              "Quizzes Available",
              style: TextStyle(fontSize: 23.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('Quiz').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    return ListView(
                      children: snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                        return _buildQuizCard(context, data['title'], document.id);
                      }).toList(),
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
