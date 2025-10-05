import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizzizz_clone/view_models/quizz_page/quizz_page_view_model.dart';

class McqDisplayWidget extends StatefulWidget {
  final Map<String, dynamic> data;

  const McqDisplayWidget({super.key, required this.data});

  @override
  State<McqDisplayWidget> createState() => _McqDisplayWidgetState();
}

class _McqDisplayWidgetState extends State<McqDisplayWidget> {
  int? selectedIndex;
  bool submitted = false;
  bool quizFinished = false;

  void _handleSubmit(QuizViewModel vm) {
    if (selectedIndex == null || submitted) return;

    final options = (widget.data['options'] as List?) ?? [];
    final correctAnswer = widget.data['answer']?.toString().trim();
    final selectedAnswer = options[selectedIndex!]?.toString().trim();

    final isCorrect = selectedAnswer == correctAnswer;

    // Add grade to view model
    vm.addGrade(isCorrect ? 1.0 : 0.0);

    setState(() {
      submitted = true; // mark as answered
    });
  }

  void _handleNext(QuizViewModel vm) {
    if (vm.hasNext) {
      vm.nextQuestion();
      setState(() {
        selectedIndex = null;
        submitted = false;
      });
    } else {
      // Last quiz, finish
      setState(() {
        quizFinished = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizViewModel>(
      builder: (context, vm, _) {
        if (quizFinished) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Quiz Finished!",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text(
                  "Your Score: ${vm.totalGrade} / ${vm.quizzes.length}",
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    vm.resetQuiz();
                    setState(() {
                      quizFinished = false;
                      submitted = false;
                      selectedIndex = null;
                    });
                  },
                  child: const Text("Restart Quiz"),
                ),
              ],
            ),
          );
        }

        final options = (widget.data['options'] as List?) ?? [];
        final correctAnswer = widget.data['answer']?.toString();

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.data['question'] ?? 'No question provided',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              if (options.isEmpty)
                const Text(
                  "No options available",
                  style: TextStyle(color: Colors.grey),
                )
              else
                ...List.generate(options.length, (index) {
                  final optionText = options[index]?.toString() ?? '';
                  final isSelected = selectedIndex == index;
                  final isCorrect = submitted && optionText == correctAnswer;

                  Color borderColor = Colors.grey;
                  if (submitted) {
                    if (isCorrect) borderColor = Colors.green;
                    else if (isSelected) borderColor = Colors.red;
                  } else if (isSelected) {
                    borderColor = Colors.blue;
                  }

                  return GestureDetector(
                    onTap: submitted
                        ? null
                        : () => setState(() => selectedIndex = index),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: borderColor, width: 2),
                      ),
                      child: Row(
                        children: [
                          Text(
                            "${String.fromCharCode(65 + index)}. ",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Expanded(
                            child: Text(
                              optionText,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          if (submitted)
                            Icon(
                              isCorrect
                                  ? Icons.check_circle
                                  : isSelected
                                      ? Icons.cancel
                                      : null,
                              color: isCorrect
                                  ? Colors.green
                                  : isSelected
                                      ? Colors.red
                                      : Colors.transparent,
                            ),
                        ],
                      ),
                    ),
                  );
                }),

              const SizedBox(height: 20),

              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (!submitted) {
                      _handleSubmit(vm);
                    } else {
                      _handleNext(vm);
                    }
                  },
                  child: Text(
                    !submitted
                        ? "Submit"
                        : (vm.hasNext ? "Next Question" : "Finish Quiz"),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
