import 'package:flutter/material.dart';
import 'package:hydration_helper/global_data.dart';

class SettingsPage extends StatelessWidget {
  final GlobalData options;
  final Function(GlobalData options) setOptions;
  const SettingsPage({
    super.key,
    required this.options,
    required this.setOptions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: options.fluidUnitsPref.index ==
                              FluidUnitsPref.flOunces.index
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                    ),
                    onPressed: () {
                      options.fluidUnitsPref = FluidUnitsPref.flOunces;
                      setOptions(options);

                      // for some reason state updates aren't propagating to this widget so the buttons don't change color
                      // can't figure out why so imma just hide that with this LOL
                      Navigator.pop(context);
                    },
                    child: const Text("Imperial"),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  FilledButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: options.fluidUnitsPref.index ==
                              FluidUnitsPref.mililiters.index
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                    ),
                    onPressed: () {
                      options.fluidUnitsPref = FluidUnitsPref.mililiters;
                      setOptions(options);
                      Navigator.pop(context);
                    },
                    child: const Text("Metric"),
                  ),
                ],
              ),
              const SizedBox(
                width: 16,
              ),
              // reset button
              FilledButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  minimumSize: const Size(328, 32),
                ),
                onPressed: () {
                  options.reset();
                  setOptions(options);
                  Navigator.pop(context);
                },
                child: const Text("Reset"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
