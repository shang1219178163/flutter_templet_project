

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/basicWidget/n_flexible_cell.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';

class AdaptiveSizeLayoutDemo extends StatefulWidget {

  AdaptiveSizeLayoutDemo({
    Key? key,
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _AdaptiveSizeLayoutDemoState createState() => _AdaptiveSizeLayoutDemoState();
}

class _AdaptiveSizeLayoutDemoState extends State<AdaptiveSizeLayoutDemo> {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => debugPrint(e),)
        ).toList(),
      ),
      body: buildBody(),
    );
  }

  buildBody() {
    return ListView(
      children: [
        for (var i = 1; i <= 4; i++) Padding(
          padding: EdgeInsets.symmetric(vertical: 4),
          child: NFlexibleCell(
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            // prefix: Container(
            //   color: Colors.red,
            //   width: 50,
            //   height: 20,
            // ),
            suffix: Padding(
              padding: EdgeInsets.only(left: 6),
              child: Icon(Icons.notification_add,
                color: Colors.white,
                size: 16,
              ),
            ),
            content: NText(
              data: "自适应横向布局"*i,
              textAlign: TextAlign.center,
              fontSize: 12.sp,
              fontColor: Colors.white,
              fontWeight: FontWeight.w500,
              maxLines: 6,
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildText(
              text: '自适应横向布局'*1,
              onTap: (){
                debugPrint("onTap");
              }
            )
          ],
        ),
      ],
    );
  }

  buildText({
    required String text,
    Color color = Colors.green,
    VoidCallback? onTap,
  }) {
    return buildTag(
      onTap: onTap,
      content: Text(text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: color),
      ),
      prefix: Padding(
        padding: EdgeInsets.only(right: 4),
        child: FlutterLogo(
          size: 20,
          textColor: color,
        ),
      ),
      suffix: Padding(
        padding: EdgeInsets.only(left: 4),
        child: Icon(Icons.arrow_forward_ios_sharp,
          size: 20,
          color: color,
        ),
      ),
    );
  }

  /// 行
  Widget buildTag({
    required VoidCallback? onTap,
    Color color = Colors.green,
    Widget? prefix,
    required Widget content,
    Widget? suffix,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          // border: Border.all(color: color),
          borderRadius: BorderRadius.all(Radius.circular(8.w)),
        ),
        constraints: BoxConstraints(
          minWidth: 40,
          maxWidth: 250,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            prefix ?? Padding(
              padding: EdgeInsets.only(right: 4),
              child: Icon(Icons.send, size: 20, color: color,),
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