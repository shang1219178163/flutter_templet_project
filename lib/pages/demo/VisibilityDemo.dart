import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_resize_switch.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Scrollbar(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: NText(
                      "isVisible",
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  NResizeSwitch(
                    value: isVisible,
                    onChanged: (bool value) {
                      isVisible = value;
                      setState(() {});
                    },
                  ),
                ],
              ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Visibility(
                    visible: isVisible,
                    // maintainAnimation: true,
                    // maintainSize: true,
                    // maintainState: true,
                    replacement: _buildItem('Visibility\nreplacement'),
                    child: _buildItem('Visibility'),
                  ),
                  Opacity(
                    opacity: isVisible ? 1 : 0.5,
                    child: _buildItem('Opacity'),
                  ),
                  AnimatedOpacity(
                    opacity: isVisible ? 1 : 0.5,
                    duration: Duration.zero,
                    child: _buildItem('AnimatedOpacity'),
                  ),
                  Offstage(
                    offstage: !isVisible,
                    child: _buildItem('Offstage'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _buildItem(String text) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.green,
        // border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
