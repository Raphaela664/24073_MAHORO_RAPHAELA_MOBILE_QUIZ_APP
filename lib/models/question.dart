class Question {
  final String? id;
  String? quizId;
  String question_description;
  List<String> options;
  int correctAnswerIndex;

  String? correctAnswer;

  Question({
    this.id,
    this.quizId,
    required this.question_description,
    required this.options,
    required this.correctAnswerIndex,
  });

  Map<String, dynamic> toJson() {
    return {
      'quizId': quizId,
      'question_description': question_description,
      'options': options,
      'correctAnswerIndex': correctAnswerIndex,
    };
  }
}
