import 'package:flutter/material.dart';
import 'package:hydration_helper/global_data.dart';
import 'package:hydration_helper/icon_text_box.dart';
import 'package:hydration_helper/icon_text_button.dart';
import 'package:hydration_helper/q_pages.dart';
import 'package:hydration_helper/question_template.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuestionBuilder extends StatefulWidget {
  final GlobalData options;
  final Function(GlobalData options) setOptions;
  const QuestionBuilder(
      {super.key, required this.options, required this.setOptions});

  @override
  State<QuestionBuilder> createState() => _QuestionBuilderState();
}

class _QuestionBuilderState extends State<QuestionBuilder> {
  String weight = "";

  // determine the next page in the QPages enum and set it to the options depending
  void _nextPage() {
    for (var page in QPages.values) {
      if (page.index == widget.options.currentPage.index + 1) {
        // if done calculate water
        if (page.index == QPages.done.index) {
          var weight = widget.options.weight;
          if (widget.options.weightUnitsPref == WeightUnitsPref.kilograms) {
            weight = (weight * 2.20462).round();
          }

          // how many ounces of water we'll need to drink
          var ounces = weight * 0.5;
          ounces *= widget.options.sex == Sex.male ? 1.1 : 1.0;

          switch (widget.options.activityLevel) {
            case ActivityLevel.moderatlyActive:
              ounces *= 1.1; // 10% more
              break;
            case ActivityLevel.veryActive:
              ounces *= 1.2; // 20% more
              break;
            default:
              break;
          }

          switch (widget.options.climate) {
            case Climate.hot:
              ounces *= 1.1; // 10% more
              break;
            case Climate.warm:
              ounces *= 1.05; // 5% more
              break;
            default:
              break;
          }

          if (widget.options.healthComplications) {
            ounces *= 1.1; // 10% more
          }

          int ouncesRounded = ounces.round();
          widget.options.recWater = ouncesRounded;
        }

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
                widget.options.healthComplications = false;
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
                            content: const Text("Weight is not a valid number"),
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
                  child: const Text("Submit"),
                ),
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
              icon: Icons.directions_run, // not actually used
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.options.fluidUnitsPref.index ==
                            FluidUnitsPref.flOunces.index
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                  ),
                  onPressed: () {
                    widget.options.fluidUnitsPref = FluidUnitsPref.flOunces;
                    widget.setOptions(widget.options);
                  },
                  child: const Text("Fluid Oz."),
                ),
                const SizedBox(
                  width: 16,
                ),
                FilledButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.options.fluidUnitsPref.index ==
                            FluidUnitsPref.mililiters.index
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                  ),
                  onPressed: () {
                    widget.options.fluidUnitsPref = FluidUnitsPref.mililiters;
                    widget.setOptions(widget.options);
                  },
                  child: const Text("Mililiters"),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Center(
              child: Text(
                widget.options.fluidUnitsPref == FluidUnitsPref.flOunces
                    ? "${widget.options.recWater}"
                    : "${widget.options.recWaterMl}",
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            if (widget.options.activityLevel == ActivityLevel.veryActive)
              const Column(
                children: [
                  IconTextBox(
                    icon: Icons.fitness_center,
                    text: "Very Active",
                    subtext: "+20% water intake",
                  ),
                  SizedBox(
                    height: 8,
                  ),
                ],
              ),
            if (widget.options.activityLevel == ActivityLevel.moderatlyActive)
              const Column(
                children: [
                  IconTextBox(
                    icon: Icons.directions_run,
                    text: "Moderately Active",
                    subtext: "+10% water intake",
                  ),
                  SizedBox(
                    height: 8,
                  ),
                ],
              ),
            if (widget.options.climate == Climate.hot)
              const Column(
                children: [
                  IconTextBox(
                    icon: Icons.local_fire_department,
                    text: "Hot or humid",
                    subtext: "+10% water intake",
                  ),
                  SizedBox(
                    height: 8,
                  ),
                ],
              ),
            if (widget.options.climate == Climate.warm)
              const Column(
                children: [
                  IconTextBox(
                    icon: Icons.directions_run, // not actually used
                    image: true, text: "Warm",
                    subtext: "+5% water intake",
                  ),
                  SizedBox(
                    height: 8,
                  ),
                ],
              ),
            if (widget.options.healthComplications)
              const Column(
                children: [
                  IconTextBox(
                    icon: Icons.local_hospital,
                    text: "Health Complications",
                    subtext: "+10% water intake",
                  ),
                  SizedBox(
                    height: 8,
                  ),
                ],
              ),
            const SizedBox(
              height: 8,
            ),
            Center(
              child: Column(
                children: [
                  FilledButton(
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all<Size>(
                        const Size(324.0, 50.0),
                      ),
                      textStyle: MaterialStateProperty.all<TextStyle>(
                        const TextStyle(fontSize: 16),
                      ),
                    ),
                    onPressed: () {
                      // set the page to the water tracker app
                      // the home page widget will handle detecting the page change and presenting a different page
                      widget.options.currentPage = QPages.waterTracker;
                      widget.setOptions(widget.options);
                    },
                    child: const Text("Continue"),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  FilledButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.grey),
                      minimumSize: MaterialStateProperty.all<Size>(
                        const Size(200.0, 40.0),
                      ),
                      textStyle: MaterialStateProperty.all<TextStyle>(
                        const TextStyle(fontSize: 14),
                      ),
                    ),
                    onPressed: () async {
                      await SharedPreferences.getInstance().then((prefs) {
                        prefs.clear();
                      });

                      widget.options.reset();
                      widget.setOptions(widget.options);
                    },
                    child: const Text("Redo questions"),
                  ),
                ],
              ),
            )
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
