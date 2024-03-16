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

// import 'package:assignment_3/pages/QuizView.dart';
// import 'package:flutter/material.dart';

// class QuizzesView extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ListView(
//         padding: EdgeInsets.all(20.0),
//         children: [
//           // Quiz card 1
//           _buildQuizCard(context, 'Quiz 1', 'images/quiz1.jpeg'),
//           SizedBox(height: 20.0),
//           // Quiz card 2
//           _buildQuizCard(context, 'Quiz 2', 'images/quiz1.jpeg'),
//           SizedBox(height: 20.0),
//           // Add more quiz cards as needed
//         ],
//       ),
//     );
//   }

//   Widget _buildQuizCard(BuildContext context, String quizTitle, String imageUrl) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => QuizView(), // Passing quiz title as ID
//           ),
//         );
//       },
//       child: Container(
//         height: 50,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(20),
//           image: DecorationImage(
//             image: AssetImage(imageUrl),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Container(
//           padding: EdgeInsets.all(20),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20),
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
//             ),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               Text(
//                 quizTitle,
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }



// import 'package:assignment_3/pages/QuizView.dart';
// import 'package:flutter/material.dart';

// class QuizzesView extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ListView(
//         padding: EdgeInsets.only(left: 10, right: 10),
//         children: [
//           // Quiz image
//           SizedBox(height: 20.0),
//           Container(
//             height: 200, 
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),
//               image: DecorationImage(
//                 image: AssetImage('images/quiz1.jpeg'),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           SizedBox(height: 20.0),
//           // Quiz list
//           _buildQuizCard(context, 'Quiz 1'),
//           SizedBox(height: 20.0),
//           _buildQuizCard(context, 'Quiz 2'),
//           SizedBox(height: 20.0),
//           // Add more quiz cards as needed
//         ],
//       ),
//     );
//   }

//   Widget _buildQuizCard(BuildContext context, String quizTitle) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => QuizView(), // Passing quiz title as ID
//           ),
//         );
//       },
//       child: Container(
//         padding: EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color: Colors.white,
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
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               quizTitle,
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
            
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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Quiz').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView(
              padding: EdgeInsets.only(left: 10, right: 10),
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                return _buildQuizCard(context, data['title'], document.id);
              }).toList(),
            );
          }
        },
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
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              quizTitle,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
