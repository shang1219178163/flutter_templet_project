
import 'package:flutter/material.dart';

class FadeTransitionBuilder extends StatefulWidget {

  FadeTransitionBuilder({
    Key? key,
    this.duration = const Duration(milliseconds: 250),
    required this.builder,
  }) : super(key: key);

  final Duration duration;

  final StatefulWidgetBuilder builder;


  @override
  _FadeTransitionBuilderState createState() => _FadeTransitionBuilderState();
}

class _FadeTransitionBuilderState extends State<FadeTransitionBuilder> with SingleTickerProviderStateMixin {

  late final AnimationController opacity;

  @override
  void initState() {
    super.initState();
    opacity = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..forward();
  }

  @override
  void dispose() {
    opacity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: opacity,
      child: widget.builder(context, setState),
    );
  }
}
