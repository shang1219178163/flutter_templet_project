//
//  VisibleContainer.dart
//  flutter_templet_project
//
//  Created by shang on 12/6/21 4:19 PM.
//  Copyright © 12/6/21 shang. All rights reserved.
//


// ignore: must_be_immutable
import 'package:flutter/material.dart';

class VisibleContainer extends StatefulWidget {

  VisibleContainer({
    Key? key,
    required this.isVisible,
    this.header,
    required this.body,
    this.indicator}) : super(key: key);

  late bool isVisible;

  final Widget? header;

  final Widget body;

  final Widget? indicator;

  @override
  _VisibleContainerState createState() => _VisibleContainerState();
}

class _VisibleContainerState extends State<VisibleContainer> {

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.green,
      child: Column(
        children: [
          if (widget.header != null) widget.header!,
          Visibility(
            visible: widget.isVisible,
            child: widget.body,
          ),
          widget.indicator ?? IconButton(
            icon: widget.isVisible ? Icon(Icons.keyboard_arrow_up) : Icon(Icons.keyboard_arrow_down),
            onPressed: () {
              setState(() {
                widget.isVisible = !widget.isVisible;
              });
            },
          ),
        ],
      ),
    );
  }
}





