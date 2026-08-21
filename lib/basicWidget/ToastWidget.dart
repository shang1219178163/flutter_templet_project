import 'package:flutter/material.dart';

class ToastWidget extends StatefulWidget {
  ToastWidget({
    super.key,
    required this.text,
    this.alignment = Alignment.center,
    this.margin = const EdgeInsets.symmetric(horizontal: 16, vertical: 56),
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    this.builder,
    this.duration = const Duration(milliseconds: 2000),
    this.transitionDuration = const Duration(milliseconds: 250),
  });

  final String text;
  final Alignment alignment;
  final EdgeInsets margin;
  final EdgeInsets padding;

  final StatefulWidgetBuilder? builder;

  final Duration duration;
  final Duration transitionDuration;

  @override
  State<ToastWidget> createState() => _ToastWidgetState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('text', text));
    properties.add(DiagnosticsProperty<Alignment>('alignment', alignment));
    properties.add(DiagnosticsProperty<EdgeInsets>('margin', margin));
    properties.add(DiagnosticsProperty<EdgeInsets>('padding', padding));
    properties.add(ObjectFlagProperty<StatefulWidgetBuilder?>.has('builder', builder));
    properties.add(DiagnosticsProperty<Duration>('duration', duration));
    properties.add(DiagnosticsProperty<Duration>('transitionDuration', transitionDuration));
  }
}

class _ToastWidgetState extends State<ToastWidget> with SingleTickerProviderStateMixin {
  late final opacityAnim = AnimationController(
    vsync: this,
    duration: widget.transitionDuration,
  );

  @override
  void initState() {
    super.initState();
    opacityAnim.forward();

    // final startFadeOutAt = widget.duration - widget.transitionDuration;
    // print('startFadeOutAt: $startFadeOutAt');
    // Future.delayed(startFadeOutAt, opacity.reverse);
  }

  @override
  void dispose() {
    opacityAnim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: opacityAnim,
      child: Align(
        alignment: widget.alignment,
        child: widget.builder?.call(context, setState) ??
            buildContainer(
              widget.text,
              margin: widget.margin,
              padding: widget.padding,
            ),
      ),
    );
  }

  //默认样式
  Widget buildContainer(
    String text, {
    EdgeInsets margin = const EdgeInsets.all(16),
    EdgeInsets padding = const EdgeInsets.all(12),
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: .65),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      margin: margin,
      padding: padding,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.white,
          decoration: TextDecoration.none,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<AnimationController>('opacityAnim', opacityAnim));
  }
}
