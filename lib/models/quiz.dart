import 'question.dart';

class Quiz {
  final String? id;
  final String title;
  final List<Question> questions;

  Quiz({
    this.id,
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
