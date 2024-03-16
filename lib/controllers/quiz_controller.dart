

// import 'package:assignment_3/models/question.dart';
// import 'package:assignment_3/models/quiz.dart';
// import 'package:assignment_3/repository/quiz_repository/question_repo.dart';
// import 'package:assignment_3/repository/quiz_repository/quiz_repository.dart';
// import 'package:get/get.dart';

// class QuizController extends GetxController {
//   static QuizController get instance => Get.find();

//   final QuestionRepository questionRepo = QuestionRepository();
//   final QuizRepository quizRepo = QuizRepository();

//   @override
//   void onInit() {
//     Get.lazyPut(() => questionRepo);
//     Get.lazyPut(() => quizRepo);
//     super.onInit();
//   }

//   void createQuestion(Question quest) {
//     questionRepo.createQuestion(quest);
//   }

//   void saveQuiz(List<Question> questions) {
//     for (int i = 0; i < questions.length; i++) {
//       createQuestion(questions[i]); 
//     }
//   }

//   void createQuiz(Quiz quiz) {
//     quizRepo.createQuiz(quiz);
//   }
// }


import 'package:assignment_3/models/quiz.dart';
import 'package:assignment_3/repository/quiz_repository/question_repo.dart';
import 'package:assignment_3/repository/quiz_repository/quiz_repository.dart';
import 'package:get/get.dart';

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

  void saveQuizWithQuestions(Quiz quiz) {
    // First, save the quiz
    quizRepo.createQuiz(quiz).then((quizId) {
      // Once the quiz is saved, save each question associated with the quiz
      quiz.questions.forEach((question) {
        // Associate the question with the quiz by passing the quizId
        question.quizId = quizId;
        // Save the question
        questionRepo.createQuestion(question);
      });
    });
  }
}

