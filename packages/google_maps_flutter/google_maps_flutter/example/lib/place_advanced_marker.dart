// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

import 'main.dart' as main;
import 'page.dart';
import 'place_marker.dart';

/// Page demonstrating how to use Advanced [Marker] class
class PlaceAdvancedMarkerPage extends GoogleMapExampleAppPage {
  /// Default constructor
  const PlaceAdvancedMarkerPage({Key? key})
      : super(const Icon(Icons.place_outlined), 'Place advanced marker',
            key: key);

  @override
  Widget build(BuildContext context) {
    return const _PlaceAdvancedMarkerBody();
  }
}

class _PlaceAdvancedMarkerBody extends PlaceMarkerBody {
  const _PlaceAdvancedMarkerBody();

  @override
  String? get mapId => main.mapId;

  @override
  Marker createMarker(
    MarkerId markerId,
    LatLng position,
    InfoWindow infoWindow,
    VoidCallback onTap,
    ValueChanged<LatLng>? onDragEnd,
    ValueChanged<LatLng>? onDrag,
  ) {
    return AdvancedMarker(
      markerId: markerId,
      position: position,
      infoWindow: infoWindow,
      onTap: onTap,
      onDrag: onDrag,
      onDragEnd: onDragEnd,
      icon: _getMarkerBitmapDescriptor(isSelected: false),
    );
  }

  @override
  Marker getSelectedMarker(Marker marker, bool isSelected) {
    return marker.copyWith(
      iconParam: _getMarkerBitmapDescriptor(isSelected: isSelected),
    );
  }

  BitmapDescriptor _getMarkerBitmapDescriptor({required bool isSelected}) {
    return BitmapDescriptor.pinConfig(
      backgroundColor: isSelected ? Colors.blue : Colors.white,
      borderColor: isSelected ? Colors.white : Colors.blue,
      glyph: Glyph.color(isSelected ? Colors.white : Colors.blue),
    );
  }
}
