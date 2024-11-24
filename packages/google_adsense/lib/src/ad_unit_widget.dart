// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:flutter/widgets.dart';
import 'package:web/web.dart' as web;

import '../google_adsense.dart';
import 'js_interop/adsbygoogle.dart';
import 'logging.dart';

/// Widget displaying an ad unit
class AdUnitWidget extends StatefulWidget {
  /// Constructs [AdUnitWidget]
  const AdUnitWidget({
    super.key,
    required String adClient,
    required AdUnitConfiguration configuration,
  })  : _adClient = adClient,
        _adUnitConfiguration = configuration;

  final String _adClient;

  final AdUnitConfiguration _adUnitConfiguration;

  @override
  State<AdUnitWidget> createState() => _AdUnitWidgetWebState();
}

class _AdUnitWidgetWebState extends State<AdUnitWidget>
    with AutomaticKeepAliveClientMixin {
  static int _adUnitCounter = 0;
  static final JSString _adStatusKey = 'adStatus'.toJS;

  // Start with a 1x1 widget size so adsense has an uncollapsed space to render the ad.
  Size _adSize = const Size(double.infinity, 1.0);

  // double _adHeight = 1.0;
  late BoxConstraints _constraints;

  @override
  bool get wantKeepAlive => true;

  static final web.ResizeObserver _adSenseResizeObserver = web.ResizeObserver(
      (JSArray<web.ResizeObserverEntry> entries, web.ResizeObserver observer) {
    for (final web.ResizeObserverEntry entry in entries.toDart) {
      final web.Element target = entry.target;
      if (target.isConnected) {
        // First time resized since attached to DOM -> attachment callback from Flutter docs by David
        _onElementAttached(target as web.HTMLElement);
        observer.disconnect();
      }
    }
  }.toJS);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // If the ad is collapsed (0x0), return an empty widget
    // if (_adSize.isEmpty) {
    //   return const SizedBox.shrink();
    // }
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      _constraints = constraints;

      if (!widget._adUnitConfiguration.params
              .containsKey(AdUnitParams.AD_FORMAT) &&
          !_adSize.isEmpty) {
        _adSize = Size(_adSize.width, constraints.maxHeight);
      }
      return SizedBox(
        height: _adSize.height,
        width: _adSize.width,
        child: HtmlElementView.fromTagName(
          tagName: 'div',
          onElementCreated: _onElementCreated,
        ),
      );
    });
  }

  void _onElementCreated(Object element) {
    // Create the `ins` element that is going to contain the actual ad.
    final web.HTMLElement insElement =
        (web.document.createElement('ins') as web.HTMLElement)
          ..className = 'adsbygoogle'
          ..style.display = 'block';

    // Apply the widget configuration to insElement
    <String, String>{
      AdUnitParams.AD_CLIENT: 'ca-pub-${widget._adClient}',
      ...widget._adUnitConfiguration.params,
    }.forEach((String key, String value) {
      insElement.dataset.setProperty(key.toJS, value.toJS);
    });

    // Adding ins inside of the adUnit
    final web.HTMLDivElement adUnitDiv = element as web.HTMLDivElement
      ..id = 'adUnit${_adUnitCounter++}'
      ..append(insElement);

    // Using Resize observer to detect element attached to DOM
    _adSenseResizeObserver.observe(adUnitDiv);

    // Using Mutation Observer to detect when adslot is being loaded based on https://support.google.com/adsense/answer/10762946?hl=en
    web.MutationObserver(
            (JSArray<JSObject> entries, web.MutationObserver observer) {
      for (final JSObject entry in entries.toDart) {
        final web.HTMLElement target =
            (entry as web.MutationRecord).target as web.HTMLElement;
        if (_isLoaded(target)) {
          if (_isFilled(target)) {
            _updateWidgetSize(Size(
              target.offsetWidth.toDouble(),
              // This is always the width of the platform view!
              target.offsetHeight.toDouble(),
            ));
          } else {
            // Prevent scrolling issues over empty ad slot
            target
              ..style.pointerEvents = 'none'
              ..style.height = '0px'
              ..style.width = '0px';
            _updateWidgetSize(Size.zero);
          }
        }
      }
    }.toJS)
        .observe(
            insElement,
            web.MutationObserverInit(
              attributes: true,
              attributeFilter: <JSString>['data-ad-status'.toJS].toJS,
            ));
  }

  static void _onElementAttached(web.HTMLElement element) {
    debugLog(
        '$element attached with w=${element.offsetWidth} and h=${element.offsetHeight}');
    adsbygoogle.requestAd();
  }

  bool _isLoaded(web.HTMLElement target) {
    final bool isLoaded =
        target.dataset.getProperty(_adStatusKey).isDefinedAndNotNull;
    debugLog('Ad isLoaded: $isLoaded');
    return isLoaded;
  }

  bool _isFilled(web.HTMLElement target) {
    final String? adStatus =
        target.dataset.getProperty<JSString?>(_adStatusKey)?.toDart;
    debugLog('Ad isFilled? $adStatus');
    if (adStatus == AdStatus.FILLED) {
      return true;
    }
    return false;
  }

  void _updateWidgetSize(Size newSize) {
    debugLog('Resizing AdUnitWidget to $newSize');
    setState(() {
      _adSize = newSize;
    });
  }
}
