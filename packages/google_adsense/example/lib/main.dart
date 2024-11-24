// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

// #docregion init
import 'package:google_adsense/google_adsense.dart';

void main() {
  adSense.initialize('0556581589806023'); // TODO: Replace with your own AdClient ID
  runApp(const MyApp());
}

// #enddocregion init
/// The main app.
class MyApp extends StatelessWidget {
  /// Constructs a [MyApp]
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

/// The home screen
class MyHomePage extends StatefulWidget {
  /// Constructs a [HomeScreen]
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('AdSense for Flutter demo app'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Responsive Ad Constrained by width of 150px:',
              ),
              Container(
                constraints: const BoxConstraints(maxWidth: 150),
                padding: const EdgeInsets.only(bottom: 10),
                child:
                    // #docregion adUnit
                    adSense.adUnit(AdUnitConfiguration.displayAdUnit(
                  adSlot: '4773943862', // TODO: Replace with your own AdSlot ID
                  adFormat: AdFormat
                      .AUTO, // Remove AdFormat to make ads limited by height
                ))
                // #enddocregion adUnit
                ,
              ),
              const Text(
                'Responsive Ad Constrained by height of 100px:',
              ),
              Container(
                constraints: const BoxConstraints(maxHeight: 100),
                padding: const EdgeInsets.only(bottom: 10),
                child: adSense.adUnit(AdUnitConfiguration.displayAdUnit(
                  adSlot: '4773943862', // TODO: Replace with your own AdSlot ID
                  // adFormat: AdFormat.AUTO, // Not using AdFormat to make ad unit respect height constraint
                )),
              ),
              const Text(
                'Fixed 125x125 size Ad:',
              ),
              Container(
                height: 125,
                width: 125,
                padding: const EdgeInsets.only(bottom: 10),
                child: adSense.adUnit(AdUnitConfiguration.displayAdUnit(
                    adSlot: '8937810400',
                    // adFormat: AdFormat.AUTO, // Not using AdFormat to make ad unit respect height constraint
                    isFullWidthResponsive: false)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
