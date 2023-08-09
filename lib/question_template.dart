import 'package:flutter/material.dart';

class QuestionTemplate extends StatelessWidget {
  final String question;
  final String? subtext;
  final List<Widget> children;
  const QuestionTemplate({
    super.key,
    required this.question,
    this.subtext,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // question text and subtext
        SizedBox(
          height: 128,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                question,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              Text(subtext ?? "", style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
        ),

        // options to answer the question, pass in these
        SizedBox(
          width: 326,
          height: 64,
          child: Column(
            children: children,
          ),
        )
      ],
    );
  }
}
