

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
        for (var i = 1; i < 20; i++) Padding(
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
              data: "自适应"*i,
              textAlign: TextAlign.center,
              fontSize: 12.sp,
              fontColor: Colors.white,
              fontWeight: FontWeight.w500,
              maxLines: 6,
            ),
          ),
        ),
      ],
    );
  }

}