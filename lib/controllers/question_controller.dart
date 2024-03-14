import 'package:assignment_3/models/question.dart';
import 'package:assignment_3/repository/quiz_repository/question_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class QuestionController extends GetxController {
  static QuestionController get instance => Get.find();

  final question_description = TextEditingController();
  
  
  final questionRepo = Get.put(QuestionRepository());
  void  createQuestion (Question question){
    questionRepo.createQuestion(question);
  }

}