import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizzizz_clone/view_models/quizz_page/quizz_page_view_model.dart';
import 'package:quizzizz_clone/views/add_quiz_page/quiz_types/fill.dart';
import 'package:quizzizz_clone/views/add_quiz_page/quiz_types/mcq/mcq.dart';
import 'package:quizzizz_clone/views/add_quiz_page/quiz_types/true_false.dart';
import 'package:quizzizz_clone/views/add_quiz_page/add_quiz_page.dart';

final Map<String, Widget Function(bool editMode, Map<String, dynamic> data, String collectionId)>
    questionTypeConfig = {
  'Multiple Choice': (editMode, data, collectionId) =>
      McqWidget(editMode: editMode, data: data, collectionId: collectionId),
  'True / False': (editMode, data, collectionId) =>
      TrueFalseWidget(editMode: editMode, data: data),
  'Fill in the Blank': (editMode, data, collectionId) =>
      FillBlankWidget(editMode: editMode, data: data),
};

class QuizPage extends StatelessWidget {
  final String collectionId;

  const QuizPage({super.key, required this.collectionId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QuizViewModel(collectionId)..loadQuizzes(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Take Quiz"),
          actions: [
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'add_quiz') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MultiProvider(
                        providers: [
                          ChangeNotifierProvider(
                            create: (_) =>
                                QuizViewModel(collectionId)..loadQuizzes(),
                          ),
                        ],
                        child: AddQuizPage(collectionId: collectionId),
                      ),
                    ),
                  );
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem(
                  value: 'add_quiz',
                  child: Text('Add Quiz'),
                ),
              ],
            ),
          ],
        ),
        body: Consumer<QuizViewModel>(
          builder: (context, vm, _) {
            if (vm.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (vm.error != null) {
              return Center(child: Text("Error: ${vm.error}"));
            }

            final quiz = vm.currentQuiz;
            if (quiz == null) {
              return const Center(child: Text("No quizzes available"));
            }

            final type = quiz['type'] ?? 'Fill in the Blank';
            final quizWidgetBuilder =
                questionTypeConfig[type] ?? questionTypeConfig['Fill in the Blank']!;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Quiz ${vm.currentIndex + 1} / ${vm.quizzes.length}",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: quizWidgetBuilder(false, quiz['data'], collectionId),
                  ),
                  
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
