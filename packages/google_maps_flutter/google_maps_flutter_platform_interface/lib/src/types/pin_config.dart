import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Color;

import '../../google_maps_flutter_platform_interface.dart';

@immutable
class PinConfig {
  const PinConfig({
    this.backgroundColor,
    this.borderColor,
    this.glyph,
  });

  final Color? backgroundColor;
  final Color? borderColor;
  final Glyph? glyph;
}

@immutable
class Glyph {
  factory Glyph.color(Color color) {
    return Glyph._(color: color);
  }

  factory Glyph.bitmap(BitmapDescriptor bitmapDescriptor) {
    return Glyph._(bitmapDescriptor: bitmapDescriptor);
  }

  factory Glyph.text({
    required String text,
    Color? textColor,
  }) {
    return Glyph._(
      text: text,
      textColor: textColor,
    );
  }
  const Glyph._({
    this.text,
    this.textColor,
    this.bitmapDescriptor,
    this.color,
  });

  final String? text;
  final Color? textColor;
  final BitmapDescriptor? bitmapDescriptor;
  final Color? color;
}
