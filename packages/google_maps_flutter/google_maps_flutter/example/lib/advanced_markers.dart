// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

import 'page.dart';

/// Map Id is required to use advanced markers
const String? _cloudMapId = null;

/// Page demonstrating advanced markers styling and behavior
class AdvancedMarkersPage extends GoogleMapExampleAppPage {
  /// Default constructor
  const AdvancedMarkersPage({Key? key})
      : super(const Icon(Icons.place_outlined), 'Advanced Markers', key: key);

  @override
  Widget build(BuildContext context) {
    return const _AdvancedMarkersBody();
  }
}

class _AdvancedMarkersBody extends StatefulWidget {
  const _AdvancedMarkersBody();

  @override
  State<_AdvancedMarkersBody> createState() => _AdvancedMarkersBodyState();
}

class _AdvancedMarkersBodyState extends State<_AdvancedMarkersBody> {
  static const LatLng marker1Location = LatLng(-33.86711, 151.1947171);
  static const LatLng marker2Location = LatLng(-32.9283, 151.7817);
  static const LatLng marker3Location = LatLng(-34.4248, 150.8931);
  static const LatLng marker4Location = LatLng(-32.9289, 150.3610);

  static const LatLng initialMapLocation = LatLng(-33.852, 151.211);
  static const double initialZoomLevel = 7.0;
  static const double collisionZoomLevel = 4.0;

  /// Whether map supports advanced markers. Null indicates capability check
  /// is in progress
  bool? _isAdvancedMarkersAvailable;

  GoogleMapController? controller;
  final Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  @override
  Widget build(BuildContext context) {
    // Check if map is capable of showing advanced markers
    if (controller != null) {
      GoogleMapsFlutterPlatform.instance
          .isAdvancedMarkersAvailable(mapId: controller!.mapId)
          .then((bool result) {
        setState(() {
          _isAdvancedMarkersAvailable = result;
        });
      });
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              switch (_isAdvancedMarkersAvailable) {
                null => 'Checking map capabilities…',
                true =>
                  'Map capabilities check result:\nthis map supports advanced markers',
                false =>
                  "Map capabilities check result:\nthis map don't support advanced markers. Please check that map Id is provided and correct map renderer is used",
              },
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: _isAdvancedMarkersAvailable == false
                        ? Colors.red
                        : null,
                  ),
            ),
          ),
          Expanded(
            child: GoogleMap(
              // ignore: avoid_redundant_argument_values
              cloudMapId: _cloudMapId,
              initialCameraPosition: const CameraPosition(
                target: initialMapLocation,
                zoom: initialZoomLevel,
              ),
              onMapCreated: _onMapCreated,
              markers: markers.values.toSet(),
            ),
          ),
          TextButton(
            onPressed: markers.isEmpty ? _addMarkers : null,
            child: const Text('Add markers'),
          ),
          TextButton(
            onPressed: markers.isEmpty ? null : _zoomOut,
            child: const Text('Zoom out (show required markers)'),
          ),
          TextButton(
            onPressed: markers.isEmpty ? null : _zoomIn,
            child: const Text('Zoom in (show all markers)'),
          ),
        ],
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      this.controller = controller;
    });
  }

  void _zoomOut() {
    controller?.animateCamera(
      CameraUpdate.newLatLngZoom(
        initialMapLocation,
        collisionZoomLevel,
      ),
    );
  }

  void _zoomIn() {
    controller?.animateCamera(
      CameraUpdate.newLatLngZoom(
        initialMapLocation,
        initialZoomLevel,
      ),
    );
  }

  Future<void> _addMarkers() async {
    final AdvancedMarker defaultMarker = AdvancedMarker(
      markerId: const MarkerId('default'),
      position: marker1Location,
      collisionBehavior: MarkerCollisionBehavior.optionalAndHidesLowerPriority,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    final AdvancedMarker colorMarker = AdvancedMarker(
      markerId: const MarkerId('custom'),
      position: marker2Location,
      collisionBehavior: MarkerCollisionBehavior.optionalAndHidesLowerPriority,
      icon: BitmapDescriptor.pinConfig(
        backgroundColor: Colors.white,
        borderColor: Colors.blue,
        glyph: Glyph.color(Colors.blue),
      ),
    );

    final AdvancedMarker textMarker = AdvancedMarker(
      markerId: const MarkerId('text'),
      position: marker3Location,
      collisionBehavior: MarkerCollisionBehavior.requiredAndHidesOptional,
      icon: BitmapDescriptor.pinConfig(
        backgroundColor: Colors.yellow,
        borderColor: Colors.red,
        glyph: Glyph.text('Hey', textColor: Colors.red),
      ),
    );

    final AdvancedMarker bitmapGlyphMarker = AdvancedMarker(
      markerId: const MarkerId('bitmapGlyph'),
      position: marker4Location,
      collisionBehavior: MarkerCollisionBehavior.optionalAndHidesLowerPriority,
      icon: BitmapDescriptor.pinConfig(
        backgroundColor: Colors.grey,
        borderColor: Colors.grey,
        glyph: Glyph.bitmap(
          await BitmapDescriptor.asset(
            const ImageConfiguration(size: Size(12, 12)),
            'assets/red_square.png',
          ),
        ),
      ),
    );

    setState(() {
      markers[defaultMarker.markerId] = defaultMarker;
      markers[colorMarker.markerId] = colorMarker;
      markers[textMarker.markerId] = textMarker;
      markers[bitmapGlyphMarker.markerId] = bitmapGlyphMarker;
    });
  }
}
