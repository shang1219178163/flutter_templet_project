import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';

class IMTipBellCell extends StatelessWidget {
  const IMTipBellCell({
    Key? key,
    this.text,
    required this.content,
    this.left,
    this.right,
    this.constraints = const BoxConstraints(
      maxWidth: 300,
    ),
  }) : super(key: key);

  final String? text;
  final Widget content;
  final Widget? left;
  final Widget? right;
  final BoxConstraints? constraints;

  @override
  Widget build(BuildContext context) {
    return buildChatNoticeCell(
      text: text,
      content: content,
      constraints: constraints,
      start: left,
      end: right,
    );
  }

  Widget buildChatNoticeCell({
    String? text,
    Widget? content,
    BoxConstraints? constraints,
    Widget? start,
    Widget? end,
  }) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 4.w),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 7.w,
        ),
        decoration: const ShapeDecoration(
          color: Color(0xffF8BC71),
          shape: StadiumBorder(),
        ),
        constraints: constraints,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            start ??
                Padding(
                  padding: EdgeInsets.only(right: 5.w),
                  child: Icon(
                    Icons.notifications_active,
                    color: Colors.white,
                    size: 15.w,
                  ),
                ),
            Flexible(
              child: content ??
                  NText(
                    text ?? "",
                    textAlign: TextAlign.center,
                    fontSize: 12.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    maxLines: 2,
                  ),
            ),
            if (end != null) end,
          ],
        ),
      ),
    );
  }
}
