import 'package:flutter/material.dart';
import 'package:quizzizz_clone/views/add_quiz_page/quiz_types/mcq/mcq_display_mode.dart';
import 'package:quizzizz_clone/views/add_quiz_page/quiz_types/mcq/mcq_edit_mode.dart';

class McqWidget extends StatelessWidget {
  final bool editMode;
  final Map<String, dynamic> data;
  final String collectionId;

  const McqWidget({super.key, required this.editMode, required this.data, required this.collectionId});

  @override
  Widget build(BuildContext context) {
    return editMode
        ? McqEditWidget(data: data,collectionId: collectionId,)
        : McqDisplayWidget(data: data);
  }
}


