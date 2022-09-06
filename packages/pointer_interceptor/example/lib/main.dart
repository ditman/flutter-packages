// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

const String _htmlElementViewType = '_htmlElementViewType';
const double _videoWidth = 320;
const double _videoHeight = 200;

/// The html.Element that will be rendered underneath the flutter UI.
html.Element htmlElement = html.IFrameElement()
  ..style.width = '100%'
  ..style.height = '100%'
  ..id = 'background-html-view'
  ..src = 'https://www.youtube.com/embed/IyFZznAk69U'
  ..style.border = 'none';

void main() {
  ui.platformViewRegistry.registerViewFactory(
    _htmlElementViewType,
    (int viewId) => htmlElement,
  );

  runApp(const MyApp());
}

/// Main app
class MyApp extends StatelessWidget {
  /// Creates main app.
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

///
class MyHomePage extends StatefulWidget {
  ///
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<void> _openDialog(BuildContext ctx) async {
    showDialog<void>(
        context: ctx,
        builder: (BuildContext context) {
          // The <slot> for this PointerInterceptor is never rendered!
          print('Find all slot tags by running:');
          print("\$('flt-glass-pane').shadowRoot.querySelectorAll('slot')");
          return PointerInterceptor(
            child: Text('Hullo!'),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HtmlElementView invisible bug'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              width: _videoWidth,
              height: _videoHeight,
              child: HtmlElementView(
                viewType: _htmlElementViewType,
              ),
            ),
            ElevatedButton(
              child: const Text('Open dialog'),
              onPressed: () {
                _openDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
