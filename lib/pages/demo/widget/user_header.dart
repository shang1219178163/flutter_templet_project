import 'package:flutter/material.dart';

/// 嵌套滚动顶部用户信息
class UserHeader extends StatelessWidget {
  const UserHeader({
    super.key,
    this.margin,
    this.constraints,
    this.decoration,
  });

  final EdgeInsets? margin;
  final BoxConstraints? constraints;
  final Decoration? decoration;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      constraints: constraints,
      alignment: Alignment.center,
      decoration: decoration ??
          BoxDecoration(
            color: Colors.yellow.withOpacity(0.3),
            image: DecorationImage(
              image: AssetImage("assets/images/bg_jiguang.png"),
              fit: BoxFit.fill,
            ),
          ),
      child: DefaultTextStyle(
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Image.asset(
                "assets/images/avatar.png",
                width: 80,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "英格兰超级联赛",
            ),
            SizedBox(height: 4),
            Text("English Premier League"),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: LinearProgressIndicator(
                minHeight: 10,
                borderRadius: BorderRadius.circular(5),
                backgroundColor: Colors.black12,
                color: Colors.white.withOpacity(0.5),
                value: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
