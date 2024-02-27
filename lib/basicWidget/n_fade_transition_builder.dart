
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

  late final controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );

  @override
  void initState() {
    super.initState();
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: controller,
      child: widget.builder(context, setState),
    );
  }
}
