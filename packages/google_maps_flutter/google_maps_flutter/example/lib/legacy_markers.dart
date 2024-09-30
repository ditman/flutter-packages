// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'page.dart';

/// Page demonstrating how to use legacy [Marker] class
class LegacyMarkersPage extends GoogleMapExampleAppPage {
  /// Default constructor
  const LegacyMarkersPage({Key? key})
      : super(const Icon(Icons.place_outlined), 'Legacy Markers', key: key);

  @override
  Widget build(BuildContext context) {
    return const _LegacyMarkersBody();
  }
}

class _LegacyMarkersBody extends StatefulWidget {
  const _LegacyMarkersBody();

  @override
  State<_LegacyMarkersBody> createState() => _LegacyMarkersBodyState();
}

class _LegacyMarkersBodyState extends State<_LegacyMarkersBody> {
  static const LatLng marker1Location = LatLng(-33.86711, 151.1947171);
  static const LatLng marker2Location = LatLng(-32.9283, 151.7817);
  static const LatLng marker3Location = LatLng(-32.9289, 150.3610);

  static const LatLng initialMapLocation = LatLng(-33.852, 151.211);
  static const double initialZoomLevel = 7.0;

  final Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: initialMapLocation,
                zoom: initialZoomLevel,
              ),
              markers: markers.values.toSet(),
            ),
          ),
          TextButton(
            onPressed: markers.isEmpty ? _addMarkers : null,
            child: const Text('Add markers'),
          ),
        ],
      ),
    );
  }

  Future<void> _addMarkers() async {
    // Create default red-pin marker
    const Marker defaultMarker = Marker(
      markerId: MarkerId('default'),
      position: marker1Location,
      infoWindow: InfoWindow(title: 'Default marker'),
    );

    // Create a colored pin marker
    final Marker colorMarker = Marker(
      markerId: const MarkerId('custom-hue'),
      position: marker2Location,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
      infoWindow: const InfoWindow(title: 'Hue marker'),
    );

    // Create a transparent bitmap marker
    final Marker bitmapGlyphMarker = Marker(
      markerId: const MarkerId('asset'),
      position: marker3Location,
      alpha: 0.75,
      icon: await BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(42, 42)),
        'assets/red_square.png',
      ),
      infoWindow: const InfoWindow(title: 'Bitmap marker'),
    );

    setState(() {
      markers[defaultMarker.markerId] = defaultMarker;
      markers[colorMarker.markerId] = colorMarker;
      markers[bitmapGlyphMarker.markerId] = bitmapGlyphMarker;
    });
  }
}
