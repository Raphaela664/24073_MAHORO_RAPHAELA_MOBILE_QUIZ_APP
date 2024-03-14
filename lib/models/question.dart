class Question {
  final String? id;
  String question_description;
  List<String> options;
  int correctAnswerIndex;

  String? correctAnswer;

  Question({
    this.id,
    required this.question_description,
    required this.options,
    required this.correctAnswerIndex,
  });

  Map<String, dynamic> toJson() {
    return {
      'question_description': question_description,
      'options': options,
      'correctAnswerIndex': correctAnswerIndex,
    };
  }
}
