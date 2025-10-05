import 'package:flutter/material.dart';

class TrueFalseWidget extends StatelessWidget {
  final bool editMode;
  final Map<String, dynamic> data;

  const TrueFalseWidget({super.key, required this.editMode, required this.data});

  @override
  Widget build(BuildContext context) {
    if (editMode) {
      return const Center(child: Text("📝 Edit Mode: True/False Editor UI here"));
    } else {
      return const Center(child: Text("📖 Display Mode: True/False Viewer UI here"));
    }
  }
}
