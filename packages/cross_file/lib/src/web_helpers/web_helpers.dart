// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:html';

/// Signature for a function that creates an [AnchorElement] suitable to download a file.
typedef AnchorElementBuilder = AnchorElement Function(String href, String? suggestedName, { bool openInNewTab, });

/// Create anchor element with download attribute.
///
/// openInNewTab is used for Chrome iOS, which has some bugs regarding the
/// download attribute:
/// * https://bugs.chromium.org/p/chromium/issues/detail?id=709986
/// * https://bugs.chromium.org/p/chromium/issues/detail?id=1150258
AnchorElement createAnchorElement(String href, String? suggestedName, {
  bool openInNewTab = false,
}) {
  final AnchorElement element = AnchorElement(href: href);

  if (openInNewTab) {
    element.target = '_blank';
    element.rel = 'noopener noreferrer';
  } else {
    if (suggestedName == null) {
      element.download = 'download';
    } else {
      element.download = suggestedName;
    }
  }

  return element;
}

/// Add an element to a container and click it
void addElementToContainerAndClick(Element container, Element element) {
  // Add the element and click it
  // All previous elements will be removed before adding the new one
  container.children.add(element);
  element.click();
}

/// Initializes a DOM container where we can host elements.
Element ensureInitialized(String id) {
  Element? target = querySelector('#$id');
  if (target == null) {
    final Element targetElement = Element.tag('flt-x-file')..id = id;

    querySelector('body')!.children.add(targetElement);
    target = targetElement;
  }
  return target;
}

final RegExp _chromeRegex = RegExp(r'CriOS', caseSensitive: false);
final RegExp _iDeviceRegex = RegExp(r'iphone|ipod|ipad', caseSensitive: false);

/// Detect if we're running in Chrome on iOs.
bool isChromeIos([String? userAgent]) {
  final String agent = userAgent ?? window.navigator.userAgent;

  return _chromeRegex.hasMatch(agent) && _iDeviceRegex.hasMatch(agent);
}
