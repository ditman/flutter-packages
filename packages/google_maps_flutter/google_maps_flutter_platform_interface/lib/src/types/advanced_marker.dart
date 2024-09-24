import 'dart:ui' show Offset;
import 'package:flutter/foundation.dart';

import '../../google_maps_flutter_platform_interface.dart';

@immutable
class AdvancedMarker extends Marker {
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
    this.altitude = 0.0,
  });

  final MarkerCollisionBehavior collisionBehavior;
  final double altitude;

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
      altitude: altitudeParam ?? altitude,
    );
  }
}

enum MarkerCollisionBehavior {
  required,
  optionalAndHidesLowerPriority,
  requiredAndHidesOptional,
}
