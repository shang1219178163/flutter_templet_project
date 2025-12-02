import 'package:flutter/material.dart';

class NLinearGradientProgressIndicator extends StatelessWidget {
  const NLinearGradientProgressIndicator({
    super.key,
    required this.value,
    this.direction = Axis.horizontal,
    this.start,
    this.end,
  });

  final double value;
  final Axis direction;

  final Widget Function(double progress)? start;
  final Widget Function(double progress)? end;

  @override
  Widget build(BuildContext context) {
    if (value == 0) {
      return const SizedBox();
    }

    final precentStr = '${(value * 100).toStringAsFixed(0)}%';
    final isHorizal = direction == Axis.horizontal;
    return Flex(
      direction: direction,
      children: [
        start?.call(value) ?? SizedBox(),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
              borderRadius: const BorderRadius.all(Radius.circular(4)),
            ),
            child: FractionallySizedBox(
              alignment: isHorizal ? Alignment.centerLeft : Alignment.bottomCenter,
              widthFactor: isHorizal ? value : null,
              heightFactor: !isHorizal ? value : null,
              child: Container(
                height: isHorizal ? 4 : null,
                width: !isHorizal ? 4 : null,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orange, Colors.pink],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
              ),
            ),
          ),
        ),
        end?.call(value) ??
            Padding(
              padding: EdgeInsets.only(
                left: isHorizal ? 4 : 0,
                top: !isHorizal ? 4 : 0,
              ),
              child: Text(
                precentStr,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
      ],
    );
  }
}
