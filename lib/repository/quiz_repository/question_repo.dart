import 'package:assignment_3/models/question.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuestionRepository extends GetxController {
  static QuestionRepository  get instance => Get.find();

  final _db = FirebaseFirestore.instance;
  
  createQuestion(Question question) async {
    await _db.collection('questions').add(question.toJson()).whenComplete(() => Get.snackbar('Success', 'Question created successfully.',
    snackPosition: SnackPosition.TOP,
    backgroundColor: Colors.green.withOpacity(0.1),
    colorText: Colors.green),

    ).catchError((error, stackTrace){
      Get.snackbar('Error', 'Something went wrong. Try again',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent.withOpacity(0.1),
      colorText: Colors.red);
      print(error.toString());
    });}


}