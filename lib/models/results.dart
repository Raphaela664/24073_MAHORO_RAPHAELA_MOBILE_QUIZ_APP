class Results {
  String id;
  String student_email;
  String quiz_id;
  String quiz_title;
  String score;

  Results({
    required this.id,
    required this.student_email,
    required this.quiz_id,
    required this.quiz_title,
    required this.score
  });

  factory Results.fromJson(Map<String, dynamic> json) {
    
  
    return Results(
      id: json['id'],
      student_email: json['student_email'],
      quiz_id: json['quiz_id'],
      quiz_title: json['quiz_title'],
      score: json['score']
    );
  }

  Map<String, dynamic> toJson() {
  

    return {
      'id': id,
      'student_email':student_email,
      'quiz_id':quiz_id,
      'quiz_title': quiz_title,
      'score': score

    };
  }
}


