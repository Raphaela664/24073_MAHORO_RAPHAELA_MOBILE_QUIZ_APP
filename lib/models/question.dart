import 'package:uuid/uuid.dart';

class Question {
  final String id;
  String? quiz_id;
  String question_description;
  String option1;
  String option2;
  String option3;
  int correct_answer_index;

  String? correctAnswer;

  Question({
    String? id,
    this.quiz_id,
    required this.question_description,
    required this.option1,
    required this.option2,
    required this.option3,
    required this.correct_answer_index,
  }) : id = id ?? Uuid().v4();

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      quiz_id: json['quiz_id'],
      question_description: json['question_description'],
      option1: json['option1'],
      option2: json['option2'],
      option3: json['option3'],
      correct_answer_index: json['correct_answer_index'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quiz_id': quiz_id,
      'question_description': question_description,
      'option1': option1,
      'option2': option2,
      'option3': option3,
      'correct_answer_index': correct_answer_index,
    };
  }
}
