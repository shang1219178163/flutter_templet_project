import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:flutter_templet_project/basicWidget/canvas_image_loader/n_canvas_image_loader.dart';
import 'package:flutter_templet_project/basicWidget/canvas_image_loader/n_image_painter.dart';
import 'package:flutter_templet_project/generated/assets.dart';

/// Canvas 加载网图
class NCanvasNetworkImage extends StatefulWidget {
  const NCanvasNetworkImage({
    super.key,
    required this.url,
    required this.width,
    required this.height,
    this.placeholder = const AssetImage(Assets.imagesIconNewsPlaceholder),
    this.fit,
    this.debugImageLabel,
    this.scale = 1.0,
    this.opacity = 1.0,
    this.colorFilter,
    this.alignment = Alignment.center,
    this.centerSlice,
    this.repeat = ImageRepeat.noRepeat,
    this.flipHorizontally = false,
    this.invertColors = false,
    this.filterQuality = FilterQuality.medium,
    this.isAntiAlias = false,
    this.blendMode = BlendMode.srcOver,
  });

  final String url;
  final double width;
  final double height;
  final AssetImage placeholder;

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
  State<NCanvasNetworkImage> createState() => _NCanvasNetworkImageState();
}

class _NCanvasNetworkImageState extends State<NCanvasNetworkImage> {
  ui.Image? image;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _load();
    });
  }

  Future<void> _load() async {
    image = await NCanvasImageLoader.load(
      widget.url,
      placeholder: widget.placeholder,
      configuration: ImageConfiguration(
        size: Size(widget.width, widget.height),
        devicePixelRatio: 3,
      ),
    );
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void didUpdateWidget(covariant NCanvasNetworkImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url ||
        oldWidget.fit != widget.fit ||
        oldWidget.colorFilter != widget.colorFilter ||
        oldWidget.blendMode != widget.blendMode ||
        oldWidget.width != widget.width ||
        oldWidget.height != widget.height ||
        oldWidget.placeholder != widget.placeholder ||
        oldWidget.debugImageLabel != widget.debugImageLabel ||
        oldWidget.scale != widget.scale ||
        oldWidget.opacity != widget.opacity ||
        oldWidget.colorFilter != widget.colorFilter ||
        oldWidget.alignment != widget.alignment ||
        oldWidget.centerSlice != widget.centerSlice ||
        oldWidget.repeat != widget.repeat ||
        oldWidget.flipHorizontally != widget.flipHorizontally ||
        oldWidget.invertColors != widget.invertColors ||
        oldWidget.filterQuality != widget.filterQuality ||
        oldWidget.isAntiAlias != widget.isAntiAlias ||
        oldWidget.blendMode != widget.blendMode) {
      if (oldWidget.url != widget.url) {
        _load();
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (image == null) {
      return Image(
        image: AssetImage(Assets.imagesIconNewsPlaceholder),
        fit: widget.fit,
        colorBlendMode: widget.blendMode,
        width: widget.width,
        height: widget.height,
        alignment: widget.alignment,
        centerSlice: widget.centerSlice,
        repeat: widget.repeat,
        filterQuality: widget.filterQuality,
        isAntiAlias: widget.isAntiAlias,
      );
    }
    return CustomPaint(
      size: Size(widget.width, widget.height),
      painter: NImagePainter(
        image: image,
        debugImageLabel: widget.debugImageLabel,
        scale: widget.scale,
        opacity: widget.opacity,
        colorFilter: widget.colorFilter,
        fit: widget.fit,
        alignment: widget.alignment,
        centerSlice: widget.centerSlice,
        repeat: widget.repeat,
        flipHorizontally: widget.flipHorizontally,
        invertColors: widget.invertColors,
        filterQuality: widget.filterQuality,
        isAntiAlias: widget.isAntiAlias,
        blendMode: widget.blendMode,
      ),
    );
  }
}
