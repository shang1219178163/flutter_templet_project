//
//  UploadButton.dart
//  flutter_templet_project
//
//  Created by shang on 12/10/21 4:30 PM.
//  Copyright © 12/10/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';

class UploadButton extends StatefulWidget {
  UploadButton({
    Key? key,
    this.image,
    this.placeholderImage,
    required this.onPressed,
    this.onDetele,
  }) : super(key: key);

  final Image? image;
  late Image? placeholderImage;
  final VoidCallback onPressed;
  final VoidCallback? onDetele;

  @override
  _UploadButtonState createState() => _UploadButtonState();
}

class _UploadButtonState extends State<UploadButton> {

  @override
  void initState() {
    if (widget.placeholderImage == null) {
      widget.placeholderImage = Image.asset(
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
    return SafeArea(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          OutlinedButton(
            onPressed: widget.onPressed,
            child: widget.image ??
              Image.asset("images/img_upload_placeholder.png", fit: BoxFit.fill),
          ),
          if (widget.onDetele != null &&
              widget.placeholderImage!.width != null &&
              widget.placeholderImage!.height != null)
            Positioned(
              right: -widget.placeholderImage!.width! * 0.5,
              top: -widget.placeholderImage!.height! * 0.5,
              child: SizedBox(
                child: IconButton(
                  icon: widget.placeholderImage!, onPressed: widget.onDetele),
              ),
            ),
        ],
      ),
    );
    ;
  }
}
