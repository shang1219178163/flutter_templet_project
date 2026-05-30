import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

class NImagePainter extends CustomPainter {
  NImagePainter({
    this.image,
    this.debugImageLabel,
    this.scale = 1.0,
    this.opacity = 1.0,
    this.colorFilter,
    this.fit,
    this.alignment = Alignment.center,
    this.centerSlice,
    this.repeat = ImageRepeat.noRepeat,
    this.flipHorizontally = false,
    this.invertColors = false,
    this.filterQuality = FilterQuality.medium,
    this.isAntiAlias = false,
    this.blendMode = BlendMode.srcOver,
  });

  final ui.Image? image;
  final String? debugImageLabel;
  final double scale;
  final double opacity;
  final ColorFilter? colorFilter;
  final BoxFit? fit;
  final Alignment alignment;
  final Rect? centerSlice;
  final ImageRepeat repeat;
  final bool flipHorizontally;
  final bool invertColors;
  final FilterQuality filterQuality;
  final bool isAntiAlias;
  final BlendMode blendMode;

  @override
  void paint(Canvas canvas, Size size) {
    if (image == null) {
      return;
    }

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    paintImage(
      canvas: canvas,
      rect: rect,
      image: image!,
      debugImageLabel: debugImageLabel,
      scale: scale,
      opacity: opacity,
      colorFilter: colorFilter,
      fit: fit,
      alignment: alignment,
      centerSlice: centerSlice,
      repeat: repeat,
      flipHorizontally: flipHorizontally,
      invertColors: invertColors,
      filterQuality: filterQuality,
      isAntiAlias: isAntiAlias,
      blendMode: blendMode,
    );
  }

  @override
  bool shouldRepaint(covariant NImagePainter oldDelegate) {
    return oldDelegate.image != image ||
        oldDelegate.debugImageLabel != debugImageLabel ||
        oldDelegate.scale != scale ||
        oldDelegate.opacity != opacity ||
        oldDelegate.colorFilter != colorFilter ||
        oldDelegate.fit != fit ||
        oldDelegate.alignment != alignment ||
        oldDelegate.centerSlice != centerSlice ||
        oldDelegate.repeat != repeat ||
        oldDelegate.flipHorizontally != flipHorizontally ||
        oldDelegate.invertColors != invertColors ||
        oldDelegate.filterQuality != filterQuality ||
        oldDelegate.isAntiAlias != isAntiAlias ||
        oldDelegate.blendMode != blendMode;
  }
}
