import 'package:flutter/material.dart';
import 'package:hydration_helper/q_options.dart';
import 'package:hydration_helper/q_pages.dart';
import 'package:hydration_helper/question_template.dart';

class QuestionBuilder extends StatefulWidget {
  final QOptions options;
  final Function(QOptions options) setOptions;
  const QuestionBuilder(
      {super.key, required this.options, required this.setOptions});

  @override
  State<QuestionBuilder> createState() => _QuestionBuilderState();
}

class _QuestionBuilderState extends State<QuestionBuilder> {
  // determine the next page in the QPages enum and set it to the options depending
  void _nextPage() {
    for (var page in QPages.values) {
      if (page.index == widget.options.currentPage.index + 1) {
        widget.options.currentPage = page;
        widget.setOptions(widget.options);
        return;
      }
    }
  }

  Widget _buildQuestion() {
    switch (widget.options.currentPage) {
      case QPages.sex:
        return QuestionTemplate(
          question: "Are you male or female?",
          children: [
            const Text("uh idk"),
          ],
        );
      case QPages.healthComplications:
        return Placeholder();
      case QPages.weight:
        return Placeholder();
      case QPages.activityLevel:
        return Placeholder();
      case QPages.climate:
        return Placeholder();
      default:
        return const Text("uh invalid page, how'd u even get here");
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildQuestion();
  }
}
