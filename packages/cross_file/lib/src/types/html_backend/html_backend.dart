// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert' show Encoding, utf8;
import 'dart:typed_data' show Uint8List;

export 'arraybuffer_html_backend.dart';
export 'blob_html_backend.dart';

/// The interface all possible HTML Backends for XFile need to implement.
abstract class HtmlBackend {
  /// Returns the URL where this storage is accessible.
  String? get url {
    throw UnimplementedError('.url');
  }

  /// Returns the contents of the storage as a list of bytes.
  Future<Uint8List> readAsBytes() async {
    throw UnimplementedError('readAsBytes');
  }

  /// Returns the size (in bytes) of the stored content.
  Future<int> length() async => (await readAsBytes()).length;

  /// Returns the stored content as a string (text).
  Future<String> readAsString({Encoding encoding = utf8}) async =>
      encoding.decode(await readAsBytes());

  /// Attempts to create a new independent [Stream] for the stored content.
  ///
  /// If `start` is present, contents will be read from byte-offset `start`. Otherwise from the beginning (index 0).
  ///
  /// If `end` is present, only up to byte-index `end` will be read. Otherwise, until end of file.
  ///
  /// In order to make sure that system resources are freed, the stream must be read to completion or the subscription on the stream must be cancelled.
  Stream<Uint8List> openRead([int? start, int? end]) async* {
    throw UnimplementedError('openRead');
  }
}
