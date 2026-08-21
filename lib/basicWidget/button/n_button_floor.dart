import 'package:flutter/material.dart';

class NButtonFloor extends StatelessWidget {
  const NButtonFloor({
    super.key,
    this.isDark = false,
    required this.title,
    required this.value,
  });

  final bool isDark;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final titleColor = isDark ? Colors.white : Colors.black87;
    final secondBgColor = isDark ? Color(0xff3A3A48) : Color(0xffdedede);
    return FittedBox(
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          border: Border.all(color: secondBgColor, width: 1),
          borderRadius: BorderRadius.circular(4),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                color: secondBgColor,
                child: Text(
                  title,
                  style: TextStyle(fontSize: 12, color: titleColor),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  value,
                  style: TextStyle(fontSize: 12, color: titleColor),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
