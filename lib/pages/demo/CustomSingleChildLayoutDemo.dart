import 'package:flutter/material.dart';

class CustomSingleChildLayoutDemo extends StatefulWidget {
  CustomSingleChildLayoutDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _CustomSingleChildLayoutDemoState createState() => _CustomSingleChildLayoutDemoState();
}

class _CustomSingleChildLayoutDemoState extends State<CustomSingleChildLayoutDemo> {
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

  Widget buildBody() {
    return Container(
      // width: 300,
      // height: 200,
      color: Colors.grey.withAlpha(11),
      constraints: BoxConstraints(
        maxHeight: 200,
        maxWidth: 300,
        minHeight: 100,
        minWidth: 150,
      ),
      child: CustomSingleChildLayout(
        delegate: _MySingleChildLayoutDelegate(),
        child: Container(
          color: Colors.orange,
        ),
      ),
    );
  }
}

class _MySingleChildLayoutDelegate extends SingleChildLayoutDelegate {
  @override
  bool shouldRelayout(SingleChildLayoutDelegate oldDelegate) {
    return true;
  }

  @override
  Size getSize(BoxConstraints constraints) {
    debugPrint('$runtimeType getSize constraints: $constraints');
    return super.getSize(constraints);
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    debugPrint('$runtimeType getPositionForChild size: $size, childSize: $childSize');
    return super.getPositionForChild(size, childSize);
  }

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    debugPrint('$runtimeType getConstraintsForChild constraints:$constraints');
    return super.getConstraintsForChild(constraints);
  }
}
