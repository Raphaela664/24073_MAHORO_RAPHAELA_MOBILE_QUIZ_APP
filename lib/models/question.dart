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

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      quizId: json['quizId'],
      question_description: json['question_description'],
      options: List<String>.from(json['options']),
      correctAnswerIndex: json['correctAnswerIndex'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quizId': quizId,
      'question_description': question_description,
      'options': options,
      'correctAnswerIndex': correctAnswerIndex,
    };
  }
}
