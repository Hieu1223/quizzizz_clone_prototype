import 'package:flutter/material.dart';

class FillBlankWidget extends StatelessWidget {
  final bool editMode;
  final Map<String, dynamic> data;

  const FillBlankWidget({super.key, required this.editMode, required this.data});

  @override
  Widget build(BuildContext context) {
    if (editMode) {
      return const Center(child: Text("📝 Edit Mode: Fill Blank Editor UI here"));
    } else {
      return const Center(child: Text("📖 Display Mode: Fill Blank Viewer UI here"));
    }
  }
}
