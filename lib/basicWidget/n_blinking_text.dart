import 'dart:async';
import 'package:flutter/material.dart';

class NBlinkingText extends StatefulWidget {
  const NBlinkingText({
    super.key,
    required this.text,
    this.interval = const Duration(seconds: 5),
    this.style,
    this.highlightedstyle,
    this.backgroudColor,
    this.highlightedBackgroudColor,
  });

  final String text;
  final Duration interval;
  final TextStyle? style;
  final TextStyle? highlightedstyle;

  final Color? backgroudColor;
  final Color? highlightedBackgroudColor;

  @override
  State<NBlinkingText> createState() => _NBlinkingTextState();
}

class _NBlinkingTextState extends State<NBlinkingText> with SingleTickerProviderStateMixin {
  bool isHighlighted = false;
  late Timer _timer;

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(widget.interval, (_) {
      isHighlighted = !isHighlighted;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = widget.style ?? Theme.of(context).textTheme.bodyLarge ?? TextStyle(color: Colors.black);
    final textStyleHighlighted = (widget.highlightedstyle ?? textStyle)!.copyWith(
      color: Colors.white,
    );

    final bgColor = widget.backgroudColor ?? Colors.transparent;
    final highlightedBgColor = widget.highlightedBackgroudColor ?? Colors.red;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: isHighlighted ? highlightedBgColor : bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 300),
        style: isHighlighted ? textStyleHighlighted : textStyle,
        child: Text(widget.text),
      ),
    );
  }
}
