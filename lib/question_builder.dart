import 'package:flutter/material.dart';
import 'package:hydration_helper/global_data.dart';
import 'package:hydration_helper/q_pages.dart';
import 'package:hydration_helper/question_template.dart';

class QuestionBuilder extends StatefulWidget {
  final GlobalData options;
  final Function(GlobalData options) setOptions;
  const QuestionBuilder(
      {super.key, required this.options, required this.setOptions});

  @override
  State<QuestionBuilder> createState() => _QuestionBuilderState();
}

class IconTextButton extends StatelessWidget {
  final IconData icon;
  final bool? image;
  final String text;
  final String? subtext;
  final Function() onPressed;
  const IconTextButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
    this.subtext,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.grey[200]),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),
      child: Row(
        children: [
          image != null && image!
              ? Image.asset("assets/astolfo.png", width: 56, height: 56)
              : Icon(icon, size: 56, color: Colors.black),
          const SizedBox(
            width: 8,
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: Theme.of(context).textTheme.headlineMedium,
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
                if (subtext != null)
                  Text(
                    subtext!,
                    style: Theme.of(context).textTheme.labelLarge,
                    softWrap:
                        true, // Allow subtext to wrap within this Text widget
                    overflow: TextOverflow
                        .visible, // Subtext can overflow its container
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _QuestionBuilderState extends State<QuestionBuilder> {
  String weight = "";

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
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color:
                        Colors.grey[200], // Set your desired background color
                  ),
                  child: IconButton(
                    padding: const EdgeInsets.symmetric(
                        vertical: 64, horizontal: 24),
                    icon: Icon(Icons.man, size: 96, color: Colors.grey[600]),
                    onPressed: () {
                      widget.options.sex = Sex.male;
                      widget.setOptions(widget.options);
                      _nextPage();
                    },
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color:
                        Colors.grey[200], // Set your desired background color
                  ),
                  child: IconButton(
                    padding: const EdgeInsets.symmetric(
                        vertical: 64, horizontal: 24),
                    icon: Icon(Icons.woman, size: 96, color: Colors.grey[600]),
                    onPressed: () {
                      widget.options.sex = Sex.female;
                      widget.setOptions(widget.options);
                      _nextPage();
                    },
                  ),
                ),
              ],
            )
          ],
        );
      case QPages.healthComplications:
        return QuestionTemplate(
          question: "Breast feeding or any health complications?",
          subtext: "Fever, vomiting, diarrhea, etc.",
          children: [
            FilledButton(
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all<Size>(
                  const Size(324.0, 50.0),
                ),
              ),
              onPressed: () {
                widget.options.healthComplications = true;
                widget.setOptions(widget.options);
                _nextPage();
              },
              child: const Text("Yes"),
            ),
            const SizedBox(
              height: 16,
            ),
            FilledButton(
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all<Size>(
                  const Size(324.0, 50.0),
                ),
              ),
              onPressed: () {
                widget.options.healthComplications = true;
                widget.setOptions(widget.options);
                _nextPage();
              },
              child: const Text("No"),
            )
          ],
        );
      case QPages.weight:
        return QuestionTemplate(
          question: "What is your current weight?",
          children: [
            Row(
              // center
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.options.weightUnitsPref.index ==
                            WeightUnitsPref.pounds.index
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                  ),
                  onPressed: () {
                    widget.options.weightUnitsPref = WeightUnitsPref.pounds;
                    widget.setOptions(widget.options);
                  },
                  child: const Text("Pounds"),
                ),
                const SizedBox(
                  width: 16,
                ),
                FilledButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.options.weightUnitsPref.index ==
                            WeightUnitsPref.kilograms.index
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                  ),
                  onPressed: () {
                    widget.options.weightUnitsPref = WeightUnitsPref.kilograms;
                    widget.setOptions(widget.options);
                  },
                  child: const Text("Kilograms"),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Column(
              children: [
                SizedBox(
                  width: 328,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Enter a number',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        weight = value;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                FilledButton(
                    onPressed: () {
                      int? value = int.tryParse(weight);

                      // show error msg
                      if (value == null) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Error'),
                              content:
                                  const Text("Weight is not a valid number"),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Ok'),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        widget.options.weight = value;
                        widget.setOptions(widget.options);
                        _nextPage();
                      }
                    },
                    child: const Text("Submit")),
              ],
            ),
          ],
        );
      case QPages.activityLevel:
        return QuestionTemplate(
          question: "How would you describe your activity level?",
          children: [
            IconTextButton(
              icon: Icons.chair,
              text: "Sedentary",
              subtext: "Little or no exercise",
              onPressed: () {
                widget.options.activityLevel = ActivityLevel.sedentary;
                widget.setOptions(widget.options);
                _nextPage();
              },
            ),
            const SizedBox(
              height: 8,
            ),
            IconTextButton(
              icon: Icons.directions_run,
              text: "Moderately Active",
              subtext: "Light exercise/sports 1-3 days a week",
              onPressed: () {
                widget.options.activityLevel = ActivityLevel.moderatlyActive;
                widget.setOptions(widget.options);
                _nextPage();
              },
            ),
            const SizedBox(
              height: 8,
            ),
            IconTextButton(
              icon: Icons.fitness_center,
              text: "Very Active",
              subtext: "Intense exercise/sports or physical job",
              onPressed: () {
                widget.options.activityLevel = ActivityLevel.veryActive;
                widget.setOptions(widget.options);
                _nextPage();
              },
            ),
          ],
        );
      case QPages.climate:
        return QuestionTemplate(
          question: "How is the overall climate in your area?",
          children: [
            IconTextButton(
              icon: Icons.local_fire_department,
              text: "Hot or humid",
              onPressed: () {
                widget.options.climate = Climate.hot;
                widget.setOptions(widget.options);
                _nextPage();
              },
            ),
            const SizedBox(
              height: 8,
            ),
            IconTextButton(
              icon: Icons.directions_run,
              image: true,
              text: "Warm",
              onPressed: () {
                widget.options.climate = Climate.warm;
                widget.setOptions(widget.options);
                _nextPage();
              },
            ),
            const SizedBox(
              height: 8,
            ),
            IconTextButton(
              icon: Icons.ac_unit,
              text: "Cold",
              onPressed: () {
                widget.options.climate = Climate.cold;
                widget.setOptions(widget.options);
                _nextPage();
              },
            ),
          ],
        );
      case QPages.done:
        return QuestionTemplate(
          question: "You should be drinking this much water per day...",
          smallText: true,
          children: [
            const Text("uhh"),
          ],
        );
      default:
        return const Text("uh invalid page, how'd u even get here");
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildQuestion();
  }
}
