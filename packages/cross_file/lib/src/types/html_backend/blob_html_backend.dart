// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:html' show HttpRequest, Blob, File, FileReader, Url;
import 'dart:typed_data' show Uint8List;

import 'html_backend.dart';

/// An HtmlBackend backed by an Blob.
class BlobHtmlBackend extends HtmlBackend {
  /// Build an BlobHtmlBackend from its internet (or document) URL.
  BlobHtmlBackend.fromUrl(String url) : _url = url;

  /// Build an BlobHtmlBackend from its contents (and mimeType).
  BlobHtmlBackend.fromData(Uint8List data, {String? mimeType}) {
    _blob = Blob(<dynamic>[data], mimeType);
    _url = Url.createObjectUrlFromBlob(_blob!);
  }

  /// Build a BlobHtmlBackend from a Blob and its (optional) url.
  BlobHtmlBackend.fromBlob(Blob blob, {String? url}) : _blob = blob {
    _url = url ?? Url.createObjectUrlFromBlob(blob);
  }

  String? _url;
  Blob? _blob;

  @override
  String? get url => _url;

  /// The underlying Blob instance.
  Future<Blob> get blob async {
    if (_blob != null) {
      return _blob!;
    }

    final HttpRequest request =
        await HttpRequest.request(_url!, responseType: 'blob');
    _blob = request.response;

    assert(_blob != null, 'Cannot retrieve data from path: $_url');

    return _blob!;
  }

  @override
  Future<Uint8List> readAsBytes() async => blob.then(_blobToByteBuffer);

  @override
  Future<int> length() async => (await blob).size;

  @override
  Stream<Uint8List> openRead([int? start, int? end]) async* {
    final Blob data = await blob;
    final Blob slice = data.slice(start ?? 0, end ?? data.size, data.type);

    yield await _blobToByteBuffer(slice);
  }

  // Converts an html Blob object to a Uint8List, through a FileReader.
  Future<Uint8List> _blobToByteBuffer(Blob blob) async {
    final FileReader reader = FileReader();
    reader.readAsArrayBuffer(blob); // This line crashes safari!

    await reader.onLoadEnd.first;

    final Uint8List? result = reader.result as Uint8List?;

    assert(result != null, 'Cannot convert Blob to bytes!');

    return result!;
  }
}
