
import 'package:assignment_3/models/quiz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuizRepository extends GetxController {
  static QuizRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  createQuiz(Quiz quiz) async {
    await _db.collection('Quiz').add(quiz.toJson()).then((quizRef) {
      // For each question in the quiz, save it with a reference to the quiz
      quiz.questions.forEach((question) {
        _db.collection('Quiz').doc(quizRef.id).collection('Questions').add(question.toJson());
      });
    }).whenComplete(() => Get.snackbar('Success', 'Quiz created successfully.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green),
    ).catchError((error, stackTrace) {
      Get.snackbar('Error', 'Something went wrong. Try again',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          colorText: Colors.red);
      print(error.toString());
    });
  }
}
