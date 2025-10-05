import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizzizz_clone/view_models/add_quiz_page/add_quizz_view_model.dart';

class McqEditWidget extends StatefulWidget {
  final Map<String, dynamic> data;
  final String collectionId;
  const McqEditWidget({super.key, required this.data, required this.collectionId});

  @override
  State<McqEditWidget> createState() => _McqEditWidgetState();
}

class _McqEditWidgetState extends State<McqEditWidget> {
  late TextEditingController _answerController;
  late TextEditingController _questionController;
  late List<TextEditingController> _optionControllers;

  @override
  void initState() {
    super.initState();

    _answerController = TextEditingController(text: widget.data['answer'] ?? '');
    _questionController = TextEditingController(text: widget.data['question'] ?? '');

    final options = (widget.data['options'] as List?) ?? [];
    _optionControllers =
        options.map((opt) => TextEditingController(text: opt.toString())).toList();

    widget.data['options'] ??= [];
    widget.data['type'] ??= 'mcq';
  }

  @override
  void dispose() {
    _answerController.dispose();
    _questionController.dispose();
    for (var c in _optionControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _addOption() {
    setState(() {
      _optionControllers.add(TextEditingController());
      widget.data['options'].add('');
    });
  }

  void _removeOption(int index) {
    setState(() {
      _optionControllers.removeAt(index);
      widget.data['options'].removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<AddQuizViewModel>();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // ✅ Correct Answer
        TextField(
          controller: _answerController,
          decoration: const InputDecoration(
            labelText: "Correct Answer",
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.check_circle_outline),
          ),
          onChanged: (val) => widget.data['answer'] = val,
        ),
        const SizedBox(height: 20),

        // 🧠 Question
        TextField(
          controller: _questionController,
          decoration: const InputDecoration(
            labelText: "Question",
            border: OutlineInputBorder(),
          ),
          onChanged: (val) => widget.data['question'] = val,
        ),
        const SizedBox(height: 20),

        // 📝 Options
        const Text(
          "Options",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        ...List.generate(_optionControllers.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _optionControllers[index],
                    decoration: InputDecoration(
                      labelText: "Option ${index + 1}",
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (val) => widget.data['options'][index] = val,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _removeOption(index),
                ),
              ],
            ),
          );
        }),

        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerLeft,
          child: ElevatedButton.icon(
            onPressed: _addOption,
            icon: const Icon(Icons.add),
            label: const Text("Add Option"),
          ),
        ),

        const SizedBox(height: 30),

        // 💾 Save button
        ElevatedButton.icon(
          onPressed: () {
            viewModel.saveQuiz(widget.collectionId, widget.data);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Quiz saved!')),
            );
          },
          icon: const Icon(Icons.save),
          label: const Text("Save Quiz"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(vertical: 14),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
