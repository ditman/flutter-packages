// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

import 'package:meta/meta.dart';

import './base.dart';
import '../web_helpers/web_helpers.dart';
import 'html_backend/html_backend.dart';

/// A CrossFile that works on web.
///
/// It wraps the bytes of a selected file.
class XFile extends XFileBase {
  /// Construct a CrossFile object from its ObjectUrl.
  ///
  /// Optionally, this can be initialized with `bytes` and `length`
  /// so no http requests are performed to retrieve files later.
  ///
  /// `name` needs to be passed from the outside, since we only have
  /// access to it while we create the ObjectUrl.
  XFile(
    String path, {
    String? mimeType,
    String? name,
    int? length,
    Uint8List? bytes,
    DateTime? lastModified,
    @visibleForTesting CrossFileTestOverrides? overrides,
  })  : _mimeType = mimeType,
        _path = path,
        _length = length,
        _overrides = overrides,
        _lastModified = lastModified ?? DateTime.fromMillisecondsSinceEpoch(0),
        _name = name ?? '',
        super(path) {
    // Cache `bytes` as Blob, if passed.
    // TODO(dit): This should be deprecated. What's the point of `fromData` then?
    if (bytes != null) {
      if (isSafari()) {
        _storage = ArrayBufferHtmlBackend.fromData(bytes);
      } else {
        _storage = BlobHtmlBackend.fromData(bytes);
      }
    } else {
      if (isSafari()) {
        _storage = ArrayBufferHtmlBackend.fromUrl(path);
      } else {
        _storage = BlobHtmlBackend.fromUrl(path);
      }
    }
  }

  /// Construct an CrossFile from its data
  XFile.fromData(
    Uint8List bytes, {
    String? mimeType,
    String? name,
    int? length,
    DateTime? lastModified,
    String? path,
    @visibleForTesting CrossFileTestOverrides? overrides,
  })  : _mimeType = mimeType,
        _length = length,
        _overrides = overrides,
        _lastModified = lastModified ?? DateTime.fromMillisecondsSinceEpoch(0),
        _name = name ?? '',
        super(path) {
    if (isSafari()) {
      _storage = ArrayBufferHtmlBackend.fromData(bytes);
    } else {
      _storage = BlobHtmlBackend.fromData(bytes);
    }
    _path = path ?? _storage.url ?? '';
  }

  // Overridable (meta) data that can be specified by the constructors.

  // MimeType of the file (eg: "image/gif").
  final String? _mimeType;
  // Name (with extension) of the file (eg: "anim.gif")
  final String _name;
  // Path of the file (must be a valid Blob URL, when set manually!)
  late String _path;
  // The size of the file (in bytes).
  final int? _length;
  // The time the file was last modified.
  final DateTime _lastModified;

  // The actual storage for the current file.
  late HtmlBackend _storage;

  // An html Element that will be used to trigger a "save as" dialog later.
  // TODO(dit): https://github.com/flutter/flutter/issues/91400 Remove this _target.
  late Element _target;

  // Overrides for testing
  // TODO(dit): https://github.com/flutter/flutter/issues/91400 Remove these _overrides,
  // they're only used to Save As...
  final CrossFileTestOverrides? _overrides;

  bool get _hasTestOverrides => _overrides != null;

  @override
  String? get mimeType => _mimeType;

  @override
  String get name => _name;

  @override
  String get path => _path;

  @override
  Future<DateTime> lastModified() async => _lastModified;

  @override
  Future<Uint8List> readAsBytes() async => _storage.readAsBytes();

  @override
  Future<int> length() async => _length ?? await _storage.length();

  @override
  Future<String> readAsString({Encoding encoding = utf8}) async =>
      _storage.readAsString(encoding: encoding);

  @override
  Stream<Uint8List> openRead([int? start, int? end]) =>
      _storage.openRead(start, end);

  /// Saves the data of this CrossFile at the location indicated by path.
  /// For the web implementation, the path variable is ignored.
  // TODO(dit): https://github.com/flutter/flutter/issues/91400
  // Move implementation to web_helpers.dart
  @override
  Future<void> saveTo(String path) async {
    // Create a DOM container where we can host the anchor.
    _target = ensureInitialized('__x_file_dom_element');

    // Create an <a> tag with the appropriate download attributes and click it
    // May be overridden with CrossFileTestOverrides
    final AnchorElement element = _hasTestOverrides
        ? _overrides!.createAnchorElement(this.path, name) as AnchorElement
        : createAnchorElement(this.path, name);

    // Clear the children in our container so we can add an element to click
    _target.children.clear();
    addElementToContainerAndClick(_target, element);
  }
}

/// Overrides some functions to allow testing
// TODO(dit): https://github.com/flutter/flutter/issues/91400
// Move this to web_helpers_test.dart
@visibleForTesting
class CrossFileTestOverrides {
  /// Default constructor for overrides
  CrossFileTestOverrides({required this.createAnchorElement});

  /// For overriding the creation of the file input element.
  Element Function(String href, String suggestedName) createAnchorElement;
}
