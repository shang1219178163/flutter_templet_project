import 'package:flutter/material.dart';

/// 列表中自适应宽度
class NFlexibleCell extends StatelessWidget {
  const NFlexibleCell({
    Key? key,
    required this.content,
    this.prefix,
    this.suffix,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 7,
    ),
    this.decoration,
    this.constraints = const BoxConstraints(
      minWidth: 100,
      maxWidth: 300,
    ),
  }) : super(key: key);

  /// 内容
  final Widget content;

  /// 前缀
  final Widget? prefix;
  // 后缀
  final Widget? suffix;

  /// 内边距
  final EdgeInsets? padding;

  /// 修饰器
  final Decoration? decoration;

  /// 约束尺寸
  final BoxConstraints? constraints;

  @override
  Widget build(BuildContext context) {
    return buildFlexibleCell(
      content: content,
      padding: padding,
      decoration: decoration,
      constraints: constraints,
      prefix: prefix,
      suffix: suffix,
    );
  }

  Widget buildFlexibleCell({
    required Widget content,
    EdgeInsets? padding,
    Decoration? decoration,
    BoxConstraints? constraints,
    Widget? prefix,
    Widget? suffix,
  }) {
    return Container(
      alignment: Alignment.center,
      child: Container(
        padding: padding,
        decoration: decoration ??
            const ShapeDecoration(
              color: Color(0xffF8BC71),
              shape: StadiumBorder(),
            ),
        constraints: constraints,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            prefix ??
                Padding(
                  padding: EdgeInsets.only(right: 6),
                  child: Icon(
                    Icons.notifications_active,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
            Flexible(
              child: content,
            ),
            if (suffix != null) suffix,
          ],
        ),
      ),
    );
  }
}
