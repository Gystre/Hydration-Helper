import 'package:flutter/material.dart';

class QuestionTemplate extends StatelessWidget {
  final String question;
  final String? subtext;
  final bool? smallText;
  final List<Widget> children;
  const QuestionTemplate({
    super.key,
    required this.question,
    this.subtext,
    this.smallText,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // question text and subtext
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question,
              style: smallText != null && smallText!
                  ? Theme.of(context).textTheme.headlineSmall
                  : Theme.of(context).textTheme.displaySmall,
            ),
            Text(subtext ?? "", style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),

        const SizedBox(
          height: 24,
        ),

        // stuff in main content
        ...children,
      ],
    );
  }
}
