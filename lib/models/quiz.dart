import 'package:assignment_3/models/question.dart';

class Quiz {
  String id;
  String title;
  List<Question> questions;

  Quiz({
    required this.id,
    required this.title,
    required this.questions,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    // Deserialize JSON into a Quiz object
    List<Question> questions = (json['questions'] as List<dynamic>)
        .map((questionJson) => Question.fromJson(questionJson))
        .toList();

    return Quiz(
      id: json['id'],
      title: json['title'],
      questions: questions,
    );
  }

  Map<String, dynamic> toJson() {
    // Serialize Quiz object into JSON
    List<Map<String, dynamic>> questionsJson =
        questions.map((question) => question.toJson()).toList();

    return {
      'id': id,
      'title': title,
      'questions': questionsJson,
    };
  }
}


