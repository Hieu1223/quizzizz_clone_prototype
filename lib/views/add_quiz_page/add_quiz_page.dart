import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizzizz_clone/view_models/add_quiz_page/add_quizz_view_model.dart';
import 'package:quizzizz_clone/views/add_quiz_page/quiz_type_config.dart';

class AddQuizPage extends StatefulWidget {
  final String collectionId;
  const AddQuizPage({super.key, required this.collectionId});

  @override
  State<AddQuizPage> createState() => _AddQuizPageState();
}

class _AddQuizPageState extends State<AddQuizPage> {
  String? selectedType;
  bool editMode = true;

  @override
  Widget build(BuildContext context) {
    final questionTypes = questionTypeConfig.keys.toList();

    return ChangeNotifierProvider(
      create: (_) => AddQuizViewModel(),
      builder: (context, _) {
        final viewModel = context.watch<AddQuizViewModel>();

        return Scaffold(
          appBar: AppBar(
            title: const Text("Add Quiz"),
            actions: [
              IconButton(
                icon: Icon(editMode ? Icons.visibility : Icons.edit),
                onPressed: () => setState(() => editMode = !editMode),
              ),
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: () {
                  viewModel.saveQuiz(widget.collectionId, viewModel.quizData);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Quiz saved successfully!")),
                  );
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  value: selectedType,
                  hint: const Text("Select Question Type"),
                  items: questionTypes
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() => selectedType = value);
                    if (value != null) {
                      viewModel.quizData['type'] = value;
                    }
                  },
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: selectedType == null
                      ? const Center(
                          child: Text("Please select a question type"),
                        )
                      : questionTypeConfig[selectedType]!(
                          editMode,
                          viewModel.quizData,
                          widget.collectionId
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
