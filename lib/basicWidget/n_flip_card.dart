import 'package:flutter/material.dart';

class NFlipCard extends StatefulWidget {
  const NFlipCard({super.key, this.fontBuilder, this.backBuilder});

  final Widget Function(VoidCallback onToggle)? fontBuilder;
  final Widget Function(VoidCallback onToggle)? backBuilder;

  @override
  State<NFlipCard> createState() => _NFlipCardState();
}

class _NFlipCardState extends State<NFlipCard> {
  bool _flipped = false;

  void toggle() {
    _flipped = !_flipped;
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant NFlipCard oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (oldWidget.fontBuilder?.call(toggle) != widget.fontBuilder?.call(toggle) ||
        oldWidget.backBuilder?.call(toggle) != widget.backBuilder?.call(toggle)) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggle,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: _flipped ? 1 : 0),
        duration: const Duration(milliseconds: 500),
        builder: (context, value, child) {
          final angle = value * 3.1415926; // 0 → π

          final isBack = angle > 3.1415926 / 2;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // 🔥 透视
              ..rotateY(angle),
            child: isBack
                ? Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(3.1415926),
                    child: buildBack(),
                  )
                : buildFront(),
          );
        },
      ),
    );
  }

  Widget buildFront() {
    return widget.fontBuilder?.call(toggle) ??
        _card(
          width: 200,
          height: 100,
          color: Colors.blue,
          text: "Front",
        );
  }

  Widget buildBack() {
    return widget.backBuilder?.call(toggle) ??
        _card(
          width: 100,
          height: 200,
          color: Colors.red,
          text: "Back",
        );
  }

  Widget _card({
    double? width,
    double? height,
    required Color color,
    required String text,
  }) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }
}
