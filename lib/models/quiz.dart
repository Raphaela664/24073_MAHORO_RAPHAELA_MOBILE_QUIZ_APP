
import 'package:assignment_3/models/question.dart';
class Quiz {
  String? id; // Change to non-nullable
  final String title;
  final List<Question> questions;

  // Updated constructor to generate id automatically if not provided
  Quiz({
    String? id,
    required this.title,
    required this.questions,
  }); // Generate a UUID if id is not provided

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
