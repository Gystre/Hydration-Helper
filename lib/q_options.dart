import 'package:hydration_helper/q_pages.dart';

enum Sex { unknown, male, female }

// 0 pounds as default for now
enum WeightUnitsPreference { unknown, pounds, kilograms }

enum Weight { unknown }

enum ActivityLevel { unknown, sedentary, moderatlyActive, veryActive }

enum Climate { unknown, hot, warm, cold }

// questionnaire options
class QOptions {
  Sex sex = Sex.unknown;
  bool healthComplications = false;
  WeightUnitsPreference weightUnitsPreference = WeightUnitsPreference.unknown;
  Weight weight = Weight.unknown;
  ActivityLevel activityLevel = ActivityLevel.unknown;
  Climate climate = Climate.unknown;
  QPages currentPage = QPages.welcome;

  bool initialized = false;

  QOptions();
}
