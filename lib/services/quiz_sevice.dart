// import 'package:assignment_3/models/question.dart';
// import 'package:assignment_3/models/quiz.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class QuizService {
//   final CollectionReference _quizCollection = FirebaseFirestore.instance.collection('quizzes');

//   // Create Quiz
//   Future<void> addQuiz(Quiz quiz) async {
//     await _quizCollection.add({
//       'title': quiz.title,
//       'questions': quiz.questions.map((question) => {
//         'question': question.question,
//         'options': question.options,
//         'correctAnswerIndex': question.correctAnswerIndex,
//       }).toList(),
//     });
//   }

//   // Read Quizzes
//   Stream<List<Quiz>> getQuizzes() {
//     return _quizCollection.snapshots().map((snapshot) => snapshot.docs.map((doc) {
//       List<Question> questions = [];
//       for (var questionData in doc.data()['questions']) {
//         questions.add(Question(
//           question: questionData['question'],
//           options: List<String>.from(questionData['options']),
//           correctAnswerIndex: questionData['correctAnswerIndex'],
//         ));
//       }
//       return Quiz(
//         id: doc.id,
//         title: doc.data()['title'],
//         questions: questions,
//       );
//     }).toList());
//   }

//   // Update Quiz
//   Future<void> updateQuiz(Quiz quiz) async {
//     await _quizCollection.doc(quiz.id).update({
//       'title': quiz.title,
//       'questions': quiz.questions.map((question) => {
//         'question': question.question,
//         'options': question.options,
//         'correctAnswerIndex': question.correctAnswerIndex,
//       }).toList(),
//     });
//   }

//   // Delete Quiz
//   Future<void> deleteQuiz(String id) async {
//     await _quizCollection.doc(id).delete();
//   }
// }
