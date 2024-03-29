import 'package:flutter/material.dart';
import 'package:hydration_helper/q_pages.dart';
import 'package:hydration_helper/global_data.dart';
import 'package:hydration_helper/question_builder.dart';
import 'package:hydration_helper/water_tracker_page.dart';
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
        textTheme: const TextTheme(
          displaySmall: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          headlineSmall: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
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
  GlobalData options = GlobalData();

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
      prefs.setInt("weight_units_preference", WeightUnitsPref.pounds.index);
      prefs.setInt("weight", 0);
      prefs.setInt("activity_level", ActivityLevel.unknown.index);
      prefs.setInt("climate", Climate.unknown.index);
      prefs.setInt("rec_water", 0);
      prefs.setInt("drank_water", 0);
      prefs.setString("last_opened", DateTime.now().toString());
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
      setState(() {
        options.healthComplications = healthComplications;
      });
    } else {
      print("healthComplications is null");
    }

    int? weightUnitsPref = prefs.getInt("weight_units_preference");
    if (weightUnitsPref != null) {
      setState(() {
        options.weightUnitsPref = WeightUnitsPref.values[weightUnitsPref];
      });
    } else {
      print("WeightUnitsPref is null");
    }

    int? weight = prefs.getInt("weight");
    if (weight != null) {
      setState(() {
        options.weight = weight;
      });
    } else {
      print("weight is null");
    }

    int? activityLevel = prefs.getInt("activity_level");
    if (activityLevel != null) {
      setState(() {
        options.activityLevel = ActivityLevel.values[activityLevel];
      });
    } else {
      print("activityLevel is null");
    }

    int? climate = prefs.getInt("climate");
    if (climate != null) {
      setState(() {
        options.climate = Climate.values[climate];
      });
    } else {
      print("climate is null");
    }

    int? recWater = prefs.getInt("rec_water");
    if (recWater != null) {
      setState(() {
        options.recWater = recWater;
      });
    } else {
      print("recWater is null");
    }

    String? lastOpened = prefs.getString("last_opened");
    print(lastOpened);
    if (lastOpened != null) {
      DateTime lastOpenedDateTime = DateTime.parse(lastOpened);
      DateTime now = DateTime.now();

      // different day, reset the drank water otherwise load the drank water
      if (lastOpenedDateTime.day != now.day) {
        print("different day, resetting drank water");
        setState(() {
          options.waterDrank = 0;
        });
        prefs.setInt("drank_water", 0);
      } else {
        int? drankWater = prefs.getInt("drank_water");
        if (drankWater != null) {
          setState(() {
            options.waterDrank = drankWater;
          });
        } else {
          print("drankWater is null");
        }
      }
    }
  }

  Future<void> saveSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setInt("questionnaire_page", options.currentPage.index);
    prefs.setInt("sex", options.sex.index);
    prefs.setBool("health_complications", options.healthComplications);
    prefs.setInt("weight_units_preference", options.weightUnitsPref.index);
    prefs.setInt("weight", options.weight);
    prefs.setInt("activity_level", options.activityLevel.index);
    prefs.setInt("climate", options.climate.index);
    prefs.setInt("rec_water", options.recWater);
    prefs.setInt("drank_water", options.waterDrank);
  }

  void setOptions(GlobalData newOptions) {
    // save all the settings
    saveSharedPrefs();

    setState(() {
      options = newOptions;
    });
  }

  @override
  Widget build(BuildContext context) {
    // user finished the questionnaire, take them to the water tracker page
    if (options.currentPage == QPages.waterTracker) {
      return WaterTrackerPage(options: options, setOptions: setOptions);
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: SingleChildScrollView(
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
                      // 2 pages don't have questions
                      value: (options.currentPage.index + 2) /
                          QPages.values.length,
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
                              SizedBox(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Welcome to Hydration Helper!',
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall),
                                    Text(
                                      "We're going to ask you a few questions to help get you started.",
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 32),
                              // this is where the content goes
                              SizedBox(
                                width: 326,
                                height: 64,
                                child: FilledButton(
                                  style: ButtonStyle(
                                    textStyle:
                                        MaterialStateProperty.all<TextStyle>(
                                      const TextStyle(fontSize: 16),
                                    ),
                                  ),
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
