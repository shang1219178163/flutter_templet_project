
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

///提供一个 render 可以圆角背景
///用法如下
//        SliverDecoratedBox(
//   sliver: SliverPadding(
//     padding: EdgeInsets.all(20),
//     sliver: SliverList(
//       delegate: SliverChildBuilderDelegate((content, index) {
//         return Container(
//           height: 65,
//           color: Colors.primaries[index % Colors.primaries.length],
//         );
//       }, childCount: 20),
//     ),
//   ),
//   decoration: BoxDecoration(
//       color: Color(0xffcc3322),
//       borderRadius: BorderRadius.all(Radius.circular(20))),
// )
class NSliverDecoratedBox extends SingleChildRenderObjectWidget {
  const NSliverDecoratedBox({
    Key? key,
    required this.decoration,
    this.position = DecorationPosition.background,
    Widget? sliver,
  })  : super(key: key, child: sliver);

  final Decoration decoration;

  final DecorationPosition position;

  @override
  RenderSliverDecoratedBox createRenderObject(BuildContext context) {
    return RenderSliverDecoratedBox(
      decoration: decoration,
      position: position,
      configuration: createLocalImageConfiguration(context),
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderSliverDecoratedBox renderObject) {
    renderObject
      ..decoration = decoration
      ..configuration = createLocalImageConfiguration(context)
      ..position = position;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    final String label;
    switch (position) {
      case DecorationPosition.background:
        label = 'bg';
        break;
      case DecorationPosition.foreground:
        label = 'fg';
        break;
    }
    properties.add(EnumProperty<DecorationPosition>('position', position,
        level: DiagnosticLevel.hidden));
    properties.add(DiagnosticsProperty<Decoration>(label, decoration));
  }
}

class RenderSliverDecoratedBox extends RenderProxySliver {
  RenderSliverDecoratedBox({
    required Decoration decoration,
    DecorationPosition position = DecorationPosition.background,
    ImageConfiguration configuration = ImageConfiguration.empty,
    RenderSliver? sliver,
  })  : _decoration = decoration,
        _position = position,
        _configuration = configuration {
    child = sliver;
  }

  BoxPainter? _painter;

  Decoration _decoration;
  Decoration get decoration => _decoration;
  set decoration(Decoration value) {
    if (value == _decoration) return;
    _painter?.dispose();
    _painter = null;
    _decoration = value;
    markNeedsPaint();
  }

  DecorationPosition _position;
  DecorationPosition get position => _position;
  set position(DecorationPosition value) {
    if (value == _position) return;
    _position = value;
    markNeedsPaint();
  }

  ImageConfiguration _configuration;
  ImageConfiguration get configuration => _configuration;
  set configuration(ImageConfiguration value) {
    if (value == _configuration) return;
    _configuration = value;
    markNeedsPaint();
  }

  @override
  void detach() {
    _painter?.dispose();
    _painter = null;
    super.detach();
    markNeedsPaint();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    var size = getAbsoluteSize();
    if (decoration is BoxDecoration) {
      var borderRadius =
          (decoration as BoxDecoration).borderRadius;
      if (borderRadius != null) {
        var clipRect = borderRadius
            .resolve(configuration.textDirection)
            .toRRect(Rect.fromLTRB(
            0, 0, constraints.crossAxisExtent, geometry!.maxPaintExtent));
        context.pushClipRRect(
          needsCompositing,
          offset,
          clipRect.outerRect,
          clipRect,
          super.paint,
        );
      }
    }
    _painter ??= _decoration.createBoxPainter(markNeedsPaint);
    final filledConfiguration =
    configuration.copyWith(size: size);
    if (position == DecorationPosition.background) {
      int? debugSaveCount;
      assert(() {
        debugSaveCount = context.canvas.getSaveCount();
        return true;
      }());
      _painter!.paint(context.canvas, offset, filledConfiguration);
      assert(() {
        if (debugSaveCount != context.canvas.getSaveCount()) {
          throw FlutterError.fromParts(<DiagnosticsNode>[
            ErrorSummary(
                '${_decoration.runtimeType} painter had mismatching save and restore calls.'),
            ErrorDescription(
              'Before painting the decoration, the canvas save count was $debugSaveCount. '
                  'After painting it, the canvas save count was ${context.canvas.getSaveCount()}. '
                  'Every call to save() or saveLayer() must be matched by a call to restore().',
            ),
            DiagnosticsProperty<Decoration>('The decoration was', decoration,
                style: DiagnosticsTreeStyle.errorProperty),
            DiagnosticsProperty<BoxPainter>('The painter was', _painter,
                style: DiagnosticsTreeStyle.errorProperty),
          ]);
        }
        return true;
      }());
      if (decoration.isComplex) context.setIsComplexHint();
    }
    super.paint(context, offset);
    if (position == DecorationPosition.foreground) {
      _painter!.paint(context.canvas, offset, filledConfiguration);
      if (decoration.isComplex) context.setIsComplexHint();
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(_decoration.toDiagnosticsNode(name: 'decoration'));
    properties.add(DiagnosticsProperty<ImageConfiguration>(
        'configuration', configuration));
  }
}
