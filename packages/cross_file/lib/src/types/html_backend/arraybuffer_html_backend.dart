// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:html' show HttpRequest, Blob, Url;
import 'dart:typed_data' show Uint8List, ByteBuffer;

import 'html_backend.dart';

/// An HtmlBackend backed by an ArrayBuffer (Uint8List).
class ArrayBufferHtmlBackend extends HtmlBackend {
  /// Build an ArrayBufferHtmlBackend from its internet (or document) URL.
  ArrayBufferHtmlBackend.fromUrl(String url) : _url = url;

  /// Build an ArrayBufferHtmlBackend from its contents.
  ArrayBufferHtmlBackend.fromData(Uint8List data, {String? mimeType})
      : _data = data {
    final Blob blob = Blob(<dynamic>[data], mimeType);
    _url = Url.createObjectUrl(blob);
  }

  String? _url;
  Uint8List? _data;

  @override
  String? get url => _url;

  @override
  Future<Uint8List> readAsBytes() async {
    if (_data != null) {
      return _data!;
    }
    final HttpRequest request =
        await HttpRequest.request(_url!, responseType: 'arraybuffer');
    final ByteBuffer? response = request.response;

    assert(response != null, 'Cannot retrieve data from path: $_url');

    _data = response!.asUint8List();

    return _data!;
  }

  @override
  Stream<Uint8List> openRead([int? start, int? end]) async* {
    final Uint8List bytes = await readAsBytes();
    yield bytes.sublist(start ?? 0, end ?? bytes.length);
  }
}
