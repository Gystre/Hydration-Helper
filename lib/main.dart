import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      //   title: Text(widget.title),
      // ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(
                  top: 128, left: 16, right: 16), // Margin of 128px from top
              height: 128,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Welcome to Hydration Helper!',
                      style:
                          TextStyle(fontSize: 29, fontWeight: FontWeight.bold)),
                  Text(
                      "We’re going to ask you a few questions to help get you started.",
                      style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
            // this is where the content goes
            Container(
              width: 326,
              height: 64,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text("Let's go!"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
