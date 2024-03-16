// import 'question.dart';

// class Quiz {
//   final String? id;
//   final String title;
//   final List<Question> questions;

//   Quiz({
//     this.id,
//     required this.title,
//     required this.questions,
//   });

//   Map<String, dynamic> toJson() {
//     List<Map<String, dynamic>> questionsJson =
//         questions.map((question) => question.toJson()).toList();

//     return {
//       'id': id,
//       'title': title,
//       'questions': questionsJson,
//     };
//   }
// }

import 'package:assignment_3/models/question.dart';
import 'package:uuid/uuid.dart'; 

class Quiz {
  final String id; // Change to non-nullable
  final String title;
  final List<Question> questions;

  // Updated constructor to generate id automatically if not provided
  Quiz({
    String? id,
    required this.title,
    required this.questions,
  }) : id = id ?? Uuid().v4(); // Generate a UUID if id is not provided

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> questionsJson =
        questions.map((question) => question.toJson()).toList();

    return {
      'id': id,
      'title': title,
      'questions': questionsJson,
    };
  }
}
