import 'dart:ui' show Offset;
import 'package:flutter/foundation.dart';

import '../../google_maps_flutter_platform_interface.dart';

/// Marks a geographical location on the map.
///
/// Extends [Marker] and provides additional features
@immutable
class AdvancedMarker extends Marker {
  /// Creates a set of marker configuration options.
  ///
  /// Default marker options.
  ///
  /// Specifies a marker that
  /// * is fully opaque; [alpha] is 1.0
  /// * uses icon bottom center to indicate map position; [anchor] is (0.5, 1.0)
  /// * has default tap handling; [consumeTapEvents] is false
  /// * is stationary; [draggable] is false
  /// * is drawn against the screen, not the map; [flat] is false
  /// * has a default icon; [icon] is `BitmapDescriptor.defaultMarker`
  /// * anchors the info window at top center; [infoWindowAnchor] is (0.5, 0.0)
  /// * has no info window text; [infoWindowText] is `InfoWindowText.noText`
  /// * is positioned at 0, 0; [position] is `LatLng(0.0, 0.0)`
  /// * has an axis-aligned icon; [rotation] is 0.0
  /// * is visible; [visible] is true
  /// * is placed at the base of the drawing order; [zIndex] is 0.0
  /// * reports [onTap] events
  /// * reports [onDragEnd] events
  /// * is always displayed on the map regardless of collision with other
  /// markers; [collisionBehavior] is [MarkerCollisionBehavior.required]
  const AdvancedMarker({
    required super.markerId,
    super.alpha,
    super.anchor,
    super.consumeTapEvents,
    super.draggable,
    super.flat,
    super.icon,
    super.infoWindow,
    super.position,
    super.rotation,
    super.visible,
    super.zIndex,
    super.clusterManagerId,
    super.onTap,
    super.onDrag,
    super.onDragStart,
    super.onDragEnd,
    this.collisionBehavior = MarkerCollisionBehavior.required,
  });

  /// Indicates how the marker behaves when it collides with other markers
  final MarkerCollisionBehavior collisionBehavior;

  /// Creates a new [Marker] object whose values are the same as this instance,
  /// unless overwritten by the specified parameters.
  @override
  AdvancedMarker copyWith({
    double? alphaParam,
    Offset? anchorParam,
    bool? consumeTapEventsParam,
    bool? draggableParam,
    bool? flatParam,
    BitmapDescriptor? iconParam,
    InfoWindow? infoWindowParam,
    LatLng? positionParam,
    double? rotationParam,
    bool? visibleParam,
    double? zIndexParam,
    VoidCallback? onTapParam,
    ValueChanged<LatLng>? onDragStartParam,
    ValueChanged<LatLng>? onDragParam,
    ValueChanged<LatLng>? onDragEndParam,
    ClusterManagerId? clusterManagerIdParam,
    MarkerCollisionBehavior? collisionBehaviorParam,
    double? altitudeParam,
  }) {
    return AdvancedMarker(
      markerId: markerId,
      alpha: alphaParam ?? alpha,
      anchor: anchorParam ?? anchor,
      consumeTapEvents: consumeTapEventsParam ?? consumeTapEvents,
      draggable: draggableParam ?? draggable,
      flat: flatParam ?? flat,
      icon: iconParam ?? icon,
      infoWindow: infoWindowParam ?? infoWindow,
      position: positionParam ?? position,
      rotation: rotationParam ?? rotation,
      visible: visibleParam ?? visible,
      zIndex: zIndexParam ?? zIndex,
      onTap: onTapParam ?? onTap,
      onDragStart: onDragStartParam ?? onDragStart,
      onDrag: onDragParam ?? onDrag,
      onDragEnd: onDragEndParam ?? onDragEnd,
      clusterManagerId: clusterManagerIdParam ?? clusterManagerId,
      collisionBehavior: collisionBehaviorParam ?? collisionBehavior,
    );
  }
}

/// Indicates how the marker behaves when it collides with other markers
enum MarkerCollisionBehavior {
  /// (default) Always display the marker regardless of collision
  required,

  /// Display the marker only if it does not overlap with other markers.
  /// If two markers of this type would overlap, the one with the higher zIndex
  /// is shown. If they have the same zIndex, the one with the lower vertical
  /// screen position is shown
  optionalAndHidesLowerPriority,

  /// Always display the marker regardless of collision, and hide any
  /// ´optionalAndHidesLowerPriority´ markers or labels that would overlap with
  /// the marker
  requiredAndHidesOptional,
}
