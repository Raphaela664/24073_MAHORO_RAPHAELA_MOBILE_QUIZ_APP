import 'question.dart';

class Quiz {
  final String id;
  final String title;
  final List<Question> questions;

  Quiz({
    required this.id,
    required this.title,
    required this.questions,
  });
}
