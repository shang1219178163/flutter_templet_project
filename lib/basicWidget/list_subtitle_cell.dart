import 'package:flutter/material.dart';

class ListSubtitleCell extends StatelessWidget {

  final EdgeInsetsGeometry? padding;

  final double spacing;

  /// Typically an [Icon] or a [CircleAvatar] widget.
  final Widget? leading;

  final Widget? title;

  final Widget? subtitle;

  final Widget? trailing;

  final Widget? subtrailing;

  const ListSubtitleCell({
    Key? key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.subtrailing,
    this.padding,
    this.spacing = 8,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.white,
      padding: padding ?? EdgeInsets.all(15),
      child: Row(
        children: <Widget>[
          if (leading != null) leading!,
          if (leading != null) Padding(padding: EdgeInsets.only(left: spacing)),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    if (title != null) Expanded(child: title!),
                    if (title != null && trailing != null) Padding(padding: EdgeInsets.only(left: spacing)),
                    if (trailing != null) trailing!,

                  ],
                ),
                if (title != null && subtitle != null || trailing != null && subtrailing != null) Padding(padding: EdgeInsets.only(top: spacing)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    if (subtitle != null) Expanded(child: subtitle!),
                    if (subtitle != null && subtrailing != null) Padding(padding: EdgeInsets.only(left: spacing)),
                    if (subtrailing != null) subtrailing!,
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
