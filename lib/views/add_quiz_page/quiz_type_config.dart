import 'package:flutter/material.dart';
import 'package:quizzizz_clone/views/add_quiz_page/quiz_types/fill.dart';
import 'package:quizzizz_clone/views/add_quiz_page/quiz_types/mcq/mcq.dart';
import 'package:quizzizz_clone/views/add_quiz_page/quiz_types/true_false.dart';


final Map<String, Widget Function(bool editMode, Map<String, dynamic> data, String collectionId)>
    questionTypeConfig = {
  'Multiple Choice': (editMode, data,collectionId) => McqWidget(editMode: editMode, data: data,collectionId: collectionId,),
  'True / False': (editMode, data,collectionId) => TrueFalseWidget(editMode: editMode, data: data),
  'Fill in the Blank': (editMode, data,collectionId) => FillBlankWidget(editMode: editMode, data: data),
};
