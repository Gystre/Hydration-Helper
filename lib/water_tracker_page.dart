import 'package:flutter/material.dart';
import 'package:hydration_helper/global_data.dart';
import 'package:hydration_helper/settings_page.dart';

class WaterTrackerPage extends StatelessWidget {
  final GlobalData options;
  final Function(GlobalData options) setOptions;
  const WaterTrackerPage({
    super.key,
    required this.options,
    required this.setOptions,
  });

  final double _cupWidth = 200;
  final double _cupHeight = 300;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hydration Helper"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // navigate to settings page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(
                    options: options,
                    setOptions: setOptions,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 16,
              ),
              Text(
                "Today's water:",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(
                options.fluidUnitsPref == FluidUnitsPref.flOunces
                    ? options.waterDrank.toString()
                    : options.waterDrankMl.toString(),
                style: Theme.of(context).textTheme.displayLarge,
              ),
              Text(
                options.fluidUnitsPref == FluidUnitsPref.flOunces
                    ? "${options.recWater.toString()} fl oz"
                    : "${options.recWaterMl.toString()} Ml",
                style: Theme.of(context).textTheme.titleSmall,
              ),
              if (options.waterDrank > options.recWater)
                Text(
                  "You've met your recommended water intake!",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              const SizedBox(
                height: 32,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: _cupWidth,
                    height: _cupHeight,
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide.none,
                        bottom: BorderSide(
                          width: 16,
                          color: Color.fromRGBO(217, 217, 217, 1.0),
                        ),
                        left: BorderSide(
                          width: 10,
                          color: Color.fromRGBO(217, 217, 217, 1.0),
                        ),
                        right: BorderSide(
                          width: 10,
                          color: Color.fromRGBO(217, 217, 217, 1.0),
                        ),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          bottom: 0,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),

                            // offset by 16 bc it's the size of the border width
                            height: (_cupHeight - 16) *
                                (options.waterDrank / options.recWater),

                            width: _cupWidth,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 32,
              ),
              FilledButton(
                onPressed: () {
                  if (options.fluidUnitsPref == FluidUnitsPref.flOunces) {
                    options.waterDrank += 1;
                  } else {
                    // it's about 3 fluid ozs to get 100ml
                    options.waterDrank += 3;
                  }
                  setOptions(options);
                },
                child: Text(
                  options.fluidUnitsPref == FluidUnitsPref.flOunces
                      ? "+1 fl oz"
                      : "+100 ml",
                ),
              ),
              FilledButton(
                onPressed: () {
                  if (options.waterDrank - 1 >= 0) {
                    if (options.fluidUnitsPref == FluidUnitsPref.flOunces) {
                      options.waterDrank -= 1;
                    } else {
                      options.waterDrank -= 3;
                    }
                    setOptions(options);
                  }
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.grey),
                ),
                child: Text(
                  options.fluidUnitsPref == FluidUnitsPref.flOunces
                      ? "-1 fl oz"
                      : "-100 ml",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
