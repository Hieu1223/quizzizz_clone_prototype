import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:quizzizz_clone/service/quizz_api.dart';

class AddQuizViewModel extends ChangeNotifier {
  final Map<String, dynamic> quizData = {};

  void updateField(String key, dynamic value) {
    quizData[key] = value;
    notifyListeners();
  }

  Future<void> saveQuiz(String collectionId, Map<String, dynamic> data) async {
    debugPrint("🧠 Saving Quiz:");
    debugPrint(jsonEncode(data));
    QuizApi.addQuiz(collectionId: collectionId, data: data);
  }
}
