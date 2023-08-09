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
  // default is in fluid ounces
  int recWater = 0;

  get recWaterMl {
    int mililiters = (recWater * 29.5735).round();
    int mililitersRounded = (mililiters / 100).floor() * 100;
    return mililitersRounded;
  }

  void reset() {
    sex = Sex.unknown;
    healthComplications = false;
    weightUnitsPref = WeightUnitsPref.pounds;
    weight = 0;
    activityLevel = ActivityLevel.unknown;
    climate = Climate.unknown;
    currentPage = QPages.welcome;
    fluidUnitsPref = FluidUnitsPref.flOunces;
    recWater = 0;
    initialized = true;
  }

  bool initialized = false;

  GlobalData();
}
