//
//  UploadButton.dart
//  flutter_templet_project
//
//  Created by shang on 12/10/21 4:30 PM.
//  Copyright © 12/10/21 shang. All rights reserved.
//

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/gesture_detector_container.dart';
import 'package:flutter_templet_project/extensions/ddlog.dart';

class UploadButton extends StatefulWidget {
  UploadButton({
    Key? key,
    required this.onPressed,
    this.image,
    this.deteleImage,
    this.onDetele,
    this.deteleWidth = 30,
    this.deteleHeight = 30,
    this.color,
  }) : super(key: key);

  final Image? image;
  late Image? deteleImage;
  final double deteleWidth;
  final double deteleHeight;
  final VoidCallback onPressed;
  final VoidCallback? onDetele;

  final Color? color;

  @override
  _UploadButtonState createState() => _UploadButtonState();
}

class _UploadButtonState extends State<UploadButton> {
  @override
  void initState() {
    if (widget.deteleImage == null) {
      widget.deteleImage = Image.asset(
        "images/icon_delete.png",
        fit: BoxFit.fill,
        width: 30,
        height: 30,
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return buildBody();
  }

  Widget buildBody() {
    return SafeArea(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: EdgeInsets.only(
              top: widget.deteleHeight * 0.5 - 3,
              right: widget.deteleWidth * 0.5 - 3),
            color: widget.color,
            child: OutlinedButton(
              onPressed: widget.onPressed,
              child: widget.image ??
                  Image.asset("images/img_upload_placeholder.png",
                      fit: BoxFit.fill),
            ),
          ),
          if (widget.onDetele != null)
            Positioned(
              right: 0,
              top: 0,
              child: SizedBox(
                width: widget.deteleWidth,
                height: widget.deteleHeight,
                child: IconButton(
                  padding: EdgeInsets.all(0),
                  icon: widget.deteleImage!,
                  onPressed: widget.onDetele
                ),
              ),
            ),
        ],
      ),
    );
  }

}


