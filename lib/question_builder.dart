import 'package:flutter/material.dart';
import 'package:hydration_helper/q_options.dart';
import 'package:hydration_helper/q_pages.dart';

class QuestionBuilder extends StatefulWidget {
  final QOptions options;
  final Function(QOptions options) setOptions;
  const QuestionBuilder(
      {super.key, required this.options, required this.setOptions});

  @override
  State<QuestionBuilder> createState() => _QuestionBuilderState();
}

class _QuestionBuilderState extends State<QuestionBuilder> {
  Widget _buildQuestion() {
    switch (widget.options.currentPage) {
      case QPages.sex:
        return Placeholder();
      case QPages.healthComplications:
        return Placeholder();
      case QPages.weight:
        return Placeholder();
      case QPages.activityLevel:
        return Placeholder();
      case QPages.climate:
        return Placeholder();
      default:
        return Container(); // Return a default widget or an empty container
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
