import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

///提供一个 render 可以圆角背景
///用法如下
//  NSliverDecoration(
//   decoration: BoxDecoration(
//       color: Color(0xffcc3322),
//       borderRadius: BorderRadius.all(Radius.circular(20)),
//   ),
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
// )

@Deprecated("已弃用,请使用 NSliverDecorated, DecoratedSliver")
class NSliverDecoration extends SingleChildRenderObjectWidget {
  const NSliverDecoration({
    super.key,
    required this.decoration,
    this.foregroundDecoration,
    Widget? sliver,
  }) : super(child: sliver);

  final Decoration decoration;
  final Decoration? foregroundDecoration;

  @override
  _NRenderSliverDecorated createRenderObject(BuildContext context) {
    return _NRenderSliverDecorated(
      decoration: decoration,
      foregroundDecoration: foregroundDecoration,
      configuration: createLocalImageConfiguration(context),
    );
  }

  @override
  void updateRenderObject(BuildContext context, _NRenderSliverDecorated renderObject) {
    renderObject
      ..decoration = decoration
      .._foregroundDecoration = foregroundDecoration
      ..configuration = createLocalImageConfiguration(context);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Decoration>('decoration', decoration));
    properties.add(DiagnosticsProperty<Decoration>("foregroundDecoration", foregroundDecoration));
  }
}

class _NRenderSliverDecorated extends RenderProxySliver {
  _NRenderSliverDecorated({
    required Decoration decoration,
    Decoration? foregroundDecoration,
    ImageConfiguration configuration = ImageConfiguration.empty,
    RenderSliver? sliver,
  })  : _decoration = decoration,
        _foregroundDecoration = foregroundDecoration,
        _configuration = configuration {
    child = sliver;
  }

  BoxPainter? _painter;

  Decoration? _foregroundDecoration;
  Decoration? get foregroundDecoration => _foregroundDecoration;
  set foregroundDecoration(Decoration? value) {
    if (value == _foregroundDecoration) {
      return;
    }
    _painter?.dispose();
    _painter = null;
    _foregroundDecoration = value;
    markNeedsPaint();
  }

  Decoration _decoration;
  Decoration get decoration => _decoration;
  set decoration(Decoration value) {
    if (value == _decoration) {
      return;
    }
    _painter?.dispose();
    _painter = null;
    _decoration = value;
    markNeedsPaint();
  }

  ImageConfiguration _configuration;
  ImageConfiguration get configuration => _configuration;
  set configuration(ImageConfiguration value) {
    if (value == _configuration) {
      return;
    }
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
      var borderRadius = (decoration as BoxDecoration).borderRadius;
      if (borderRadius != null) {
        var clipRect = borderRadius
            .resolve(configuration.textDirection)
            .toRRect(Rect.fromLTRB(0, 0, constraints.crossAxisExtent, geometry!.maxPaintExtent));
        context.pushClipRRect(needsCompositing, offset, clipRect.outerRect, clipRect, super.paint);
      }
    }
    _painter ??= decoration.createBoxPainter(markNeedsPaint);
    final filledConfiguration = configuration.copyWith(size: size);
    // if (position == DecorationPosition.background) {
    int? debugSaveCount;
    assert(() {
      debugSaveCount = context.canvas.getSaveCount();
      return true;
    }());
    _painter!.paint(context.canvas, offset, filledConfiguration);
    assert(() {
      if (debugSaveCount != context.canvas.getSaveCount()) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary('${_decoration.runtimeType} painter had mismatching save and restore calls.'),
          ErrorDescription(
            'Before painting the decoration, the canvas save count was $debugSaveCount. '
            'After painting it, the canvas save count was ${context.canvas.getSaveCount()}. '
            'Every call to save() or saveLayer() must be matched by a call to restore().',
          ),
          DiagnosticsProperty<Decoration>('The decoration was', decoration, style: DiagnosticsTreeStyle.errorProperty),
          DiagnosticsProperty<BoxPainter>('The painter was', _painter, style: DiagnosticsTreeStyle.errorProperty),
        ]);
      }
      return true;
    }());
    if (decoration.isComplex) {
      context.setIsComplexHint();
    }
    // }
    super.paint(context, offset);
    if (foregroundDecoration != null) {
      if (foregroundDecoration is BoxDecoration) {
        var borderRadius = (foregroundDecoration! as BoxDecoration).borderRadius;
        if (borderRadius != null) {
          var clipRect = borderRadius
              .resolve(configuration.textDirection)
              .toRRect(Rect.fromLTRB(0, 0, constraints.crossAxisExtent, geometry!.maxPaintExtent));
          context.pushClipRRect(needsCompositing, offset, clipRect.outerRect, clipRect, super.paint);
        }
      }
      _painter = foregroundDecoration!.createBoxPainter(markNeedsPaint);
      _painter!.paint(context.canvas, offset, filledConfiguration);
      if (foregroundDecoration!.isComplex) {
        context.setIsComplexHint();
      }
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(_decoration.toDiagnosticsNode(name: 'decoration'));
    properties.add(DiagnosticsProperty<Decoration>('foregroundDecoration', foregroundDecoration, defaultValue: null));
    properties.add(DiagnosticsProperty<ImageConfiguration>('configuration', configuration));
  }
}
