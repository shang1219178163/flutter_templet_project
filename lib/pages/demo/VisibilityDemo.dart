import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/color_ext.dart';

class VisibilityDemo extends StatefulWidget {
  const VisibilityDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _VisibilityDemoState createState() => _VisibilityDemoState();
}

class _VisibilityDemoState extends State<VisibilityDemo> {
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
          actions: [
            'done',
          ]
              .map((e) => TextButton(
                    onPressed: onDone,
                    child: Text(
                      e,
                      style: TextStyle(color: Colors.white),
                    ),
                  ))
              .toList(),
        ),
        body: _buildBody());
  }

  _buildBody() {
    final child = Container(
      width: 100,
      height: 100,
      color: ColorExt.random,
    );
    return Container(
      child: Row(
        children: <Widget>[
          Visibility(
            visible: isVisible,
            maintainAnimation: true,
            maintainSize: true,
            maintainState: true,
            child: _buildItem('Visibility'),
          ),
          // VerticalDivider(),
          Offstage(
            offstage: !isVisible,
            child: _buildItem('Offstage'),
          ),
          // VerticalDivider(),
          Opacity(
            opacity: isVisible ? 1 : 0.5,
            child: _buildItem('Opacity'),
          ),
        ],
      ),
    );
  }

  _buildItem(String text) {
    return Container(
      width: 100,
      height: 100,
      color: ColorExt.random,
      child: Text(text),
    );
  }

  onDone() {
    isVisible = !isVisible;
    setState(() {});
  }
}
