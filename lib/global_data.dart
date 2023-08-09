import 'package:hydration_helper/q_pages.dart';

enum Sex { unknown, male, female }

// how the user's weight number will be interpreted
enum WeightUnitsPref { pounds, kilograms }

// how the user's recWater number will be interpreted
enum FluidUnitsPref { flOunces, mililiters }

enum ActivityLevel { unknown, sedentary, moderatlyActive, veryActive }

enum Climate { unknown, hot, warm, cold }

// questionnaire options
class GlobalData {
  Sex sex = Sex.unknown;
  bool healthComplications = false;
  WeightUnitsPref weightUnitsPref = WeightUnitsPref.pounds;
  int weight = 0;
  ActivityLevel activityLevel = ActivityLevel.unknown;
  Climate climate = Climate.unknown;
  QPages currentPage = QPages.welcome;

  FluidUnitsPref fluidUnitsPref = FluidUnitsPref.flOunces;

  // recommended amount of water calculated via some math
  int recWater = 0;

  bool initialized = false;

  GlobalData();
}
