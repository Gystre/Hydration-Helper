import 'package:flutter/material.dart';
import 'package:hydration_helper/q_pages.dart';
import 'package:hydration_helper/q_options.dart';
import 'package:hydration_helper/question_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hydration Helper',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: "Hydration Helper"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  QOptions options = QOptions();

  @override
  void initState() {
    super.initState();
    loadSharedPreferences();
  }

  Future<void> loadSharedPreferences() async {
    // load the saved settings from storage, if none exist then create the default settings
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // no prefs exist, first time opening app so initialize all the key value pairs
    if (!prefs.containsKey("questionnaire_page")) {
      prefs.setInt("questionnaire_page", QPages.welcome.index);
      prefs.setInt("sex", Sex.unknown.index);
      prefs.setBool("health_complications", false);
      prefs.setInt(
          "weight_units_preference", WeightUnitsPreference.unknown.index);
      prefs.setInt("weight", Weight.unknown.index);
      prefs.setInt("activity_level", ActivityLevel.unknown.index);
      prefs.setInt("climate", Climate.unknown.index);
      print("Created prefs");
      return;
    }

    if (!mounted) {
      return;
    }

    // they should all exist, load them from storage
    int? qPage = prefs.getInt("questionnaire_page");
    if (qPage != null) {
      setState(() {
        options.currentPage = QPages.values[qPage];
      });
    } else {
      print("qPage is null");
    }

    int? sex = prefs.getInt("sex");
    if (sex != null) {
      setState(
        () {
          options.sex = Sex.values[sex];
        },
      );
    } else {
      print("sex is null");
    }

    bool? healthComplications = prefs.getBool("health_complications");
    if (healthComplications != null) {
      setState(
        () {
          options.healthComplications = healthComplications;
        },
      );
    } else {
      print("healthComplications is null");
    }

    int? weightUnitsPreference = prefs.getInt("weight_units_preference");
    if (weightUnitsPreference != null) {
      setState(
        () {
          options.weightUnitsPreference =
              WeightUnitsPreference.values[weightUnitsPreference];
        },
      );
    } else {
      print("weightUnitsPreference is null");
    }

    int? weight = prefs.getInt("weight");
    if (weight != null) {
      setState(
        () {
          options.weight = Weight.values[weight];
        },
      );
    } else {
      print("weight is null");
    }

    int? activityLevel = prefs.getInt("activity_level");
    if (activityLevel != null) {
      setState(
        () {
          options.activityLevel = ActivityLevel.values[activityLevel];
        },
      );
    } else {
      print("activityLevel is null");
    }

    int? climate = prefs.getInt("climate");
    if (climate != null) {
      setState(
        () {
          options.climate = Climate.values[climate];
        },
      );
    } else {
      print("climate is null");
    }

    // settings initialized
    setState(
      () => options.initialized = true,
    );
  }

  void setOptions(QOptions newOptions) {
    // save all the settings

    setState(() {
      options = newOptions;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!options.initialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      //   title: Text(widget.title),
      // ),
      // F: make column layout with 3 parts: progress bar, question, and options
      // make the progress bar invivisible on the welcome page
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Opacity(
                opacity:
                    options.currentPage.index == QPages.welcome.index ? 0 : 1,
                child: Container(
                  margin: const EdgeInsets.only(top: 64),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      minHeight: 8,
                      value: options.currentPage.index / QPages.values.length,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 128,
                  left: 16,
                  right: 16,
                ),
                child:
                    // render either the welcome text or the questions
                    options.currentPage.index == QPages.welcome.index
                        ? Column(
                            children: [
                              const SizedBox(
                                height: 128,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Welcome to Hydration Helper!',
                                        style: TextStyle(
                                            fontSize: 29,
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                        "We're going to ask you a few questions to help get you started.",
                                        style: TextStyle(fontSize: 14)),
                                  ],
                                ),
                              ),
                              // this is where the content goes
                              SizedBox(
                                width: 326,
                                height: 64,
                                child: ElevatedButton(
                                  onPressed: () {
                                    options.currentPage = QPages.sex;
                                    setOptions(options);
                                  },
                                  child: const Text("Start"),
                                ),
                              ),
                            ],
                          )
                        : QuestionBuilder(
                            options: options,
                            setOptions: setOptions,
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
