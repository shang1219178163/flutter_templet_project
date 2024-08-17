//
//  NnImageLoading.dart
//  flutter_templet_project
//
//  Created by shang on 3/24/23 10:44 AM.
//  Copyright © 3/24/23 shang. All rights reserved.
//

import 'package:flutter/material.dart';

class NImageLoading extends StatelessWidget {
  const NImageLoading({
    Key? key,
    this.title,
    required this.image,
    required this.placeholder,
  }) : super(key: key);

  final ImageProvider image;
  final Widget placeholder;

  final String? title;

  @override
  Widget build(BuildContext context) {
    return Image(
      image: image,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded == true) {
          return child;
        }

        return AnimatedOpacity(
          opacity: frame != null ? 1 : 0,
          duration: Duration(milliseconds: 300),
          child: frame != null ? child : placeholder,
        );
      },
      loadingBuilder: (context, child, ImageChunkEvent? loadingProgress) {
        var val = 0.0;
        if (loadingProgress != null &&
            loadingProgress.cumulativeBytesLoaded != 0 &&
            loadingProgress.expectedTotalBytes != 0) {
          val = loadingProgress.cumulativeBytesLoaded.toDouble() /
              loadingProgress.expectedTotalBytes!.toDouble();
        }

        return Center(
          child: CircularProgressIndicator(
            value: val,
          ),
        );
      },
    );
  }
}
