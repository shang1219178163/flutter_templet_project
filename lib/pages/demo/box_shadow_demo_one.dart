import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';

/// 内外阴影,缺点需要固定宽高
class BoxShadowDemoOne extends StatefulWidget {
  BoxShadowDemoOne({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _BoxShadowDemoOneState createState() => _BoxShadowDemoOneState();
}

class _BoxShadowDemoOneState extends State<BoxShadowDemoOne> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
          actions: [
            'done',
          ]
              .map((e) => TextButton(
                    child: Text(
                      e,
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () => debugPrint(e),
                  ))
              .toList(),
        ),
        body: buildBody(),
    );
  }

  buildBody() {
    return Container(
      padding: EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            buildShadow(
              width: 60,
              height: 60,
              child: NText(data: "内外阴影"),
            ),
            SizedBox(height: 10,),
            buildShadow(
              width: 100,
              height: 100,
              child: NText(data: "内外阴影"),
            ),
            SizedBox(height: 10,),
            buildShadow(
              width: 100,
              height: 50,
              child: NText(data: "内外阴影"),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildShadow({
    required Widget child,
    double? width,
    double? height,
  }) {
    return Container(
      width: width,
      height: height,
      // constraints: BoxConstraints(
      //   maxHeight: double.maxFinite,
      //   maxWidth: double.maxFinite,
      //   minWidth: 0,
      //   minHeight: 0,
      // ),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFFE8E8E8),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFE8E8E8),
                  offset: Offset(8, 8),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(63),
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFF7F7F7),
                    offset: Offset(3, 3),
                    blurRadius: 3,
                    spreadRadius: 1,
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
