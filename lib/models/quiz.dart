import 'package:assignment_3/models/question.dart';
import 'package:uuid/uuid.dart';

class Quiz {
  late final String id; // Change to non-nullable
  final String title;
  final List<Question> questions;

  Quiz({
    required this.id,
    required this.title,
    required this.questions,
  });

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


