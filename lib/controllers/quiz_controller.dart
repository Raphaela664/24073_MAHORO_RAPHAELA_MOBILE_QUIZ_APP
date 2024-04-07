import 'package:assignment_3/models/quiz.dart';
import 'package:assignment_3/models/question.dart';
import 'package:assignment_3/repository/quiz_repository/question_repo.dart';
import 'package:assignment_3/repository/quiz_repository/quiz_repository.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class QuizController extends GetxController {
  static QuizController get instance => Get.find();

  final QuestionRepository questionRepo = QuestionRepository();
  final QuizRepository quizRepo = QuizRepository();

  @override
  void onInit() {
    Get.lazyPut(() => questionRepo);
    Get.lazyPut(() => quizRepo);
    super.onInit();
  }

  Future<void> saveQuizWithQuestions(BuildContext context, Quiz quiz) async {
    try {
      // Generate quizId
      String quizId = Uuid().v4();

      // Set quizId for each question
      quiz.questions.forEach((question) {
        question.quiz_id = quizId;
      });
      quiz.id = quizId;

      // Save the quiz
      await quizRepo.createQuiz(context, quiz);

      // Save each question associated with the quiz
      for (Question question in quiz.questions) {
        await questionRepo.createQuestion(question);
      }
    } catch (e) {
      // Handle any errors that occur during the process
      print('Error saving quiz with questions: $e');
    }
  }
}