import 'package:flutter/foundation.dart';
import 'package:quizzizz_clone/service/quizz_api.dart';

class QuizViewModel extends ChangeNotifier {
  final String collectionId;

  List<Map<String, dynamic>> quizzes = [];
  int currentIndex = 0;
  bool isLoading = false;
  String? error;

  // Optional: store cumulative grade or scores per quiz
  final Map<int, double> _grades = {};

  QuizViewModel(this.collectionId);

  Map<String, dynamic>? get currentQuiz {
    if (quizzes.isEmpty || currentIndex < 0 || currentIndex >= quizzes.length) return null;
    return quizzes[currentIndex];
  }

    // inside QuizViewModel
  void resetQuiz() {
    currentIndex = 0;
    _grades.clear();
    notifyListeners();
  }



  Future<void> loadQuizzes() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final data = await QuizApi.getQuizzes(collectionId);
      quizzes = List<Map<String, dynamic>>.from(data);
      currentIndex = 0;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void nextQuestion() {
    if (currentIndex < quizzes.length - 1) {
      currentIndex++;
      notifyListeners();
    }
  }

  void previousQuestion() {
    if (currentIndex > 0) {
      currentIndex--;
      notifyListeners();
    }
  }

  bool get hasNext => currentIndex < quizzes.length - 1;
  bool get hasPrevious => currentIndex > 0;

  // ----------------------------
  // Grading
  // ----------------------------
  void addGrade(double value) {
    _grades[currentIndex] = (_grades[currentIndex] ?? 0) + value;
  }

  double getGrade([int? index]) {
    index ??= currentIndex;
    return _grades[index] ?? 0;
  }

  double get totalGrade => _grades.values.fold(0.0, (sum, g) => sum + g);
}
