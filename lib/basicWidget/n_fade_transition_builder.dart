
import 'package:flutter/material.dart';

class NFadeTransitionBuilder extends StatefulWidget {

  NFadeTransitionBuilder({
    Key? key,
    this.duration = const Duration(milliseconds: 250),
    required this.builder,
  }) : super(key: key);

  final Duration duration;

  final StatefulWidgetBuilder builder;


  @override
  _NFadeTransitionBuilderState createState() => _NFadeTransitionBuilderState();
}

class _NFadeTransitionBuilderState extends State<NFadeTransitionBuilder> with SingleTickerProviderStateMixin {

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
