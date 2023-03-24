//
//  NnImageLoading.dart
//  flutter_templet_project
//
//  Created by shang on 3/24/23 10:44 AM.
//  Copyright © 3/24/23 shang. All rights reserved.
//


import 'package:flutter/material.dart';

class NNImageLoading extends StatelessWidget {

  const NNImageLoading({
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

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: frame != null ? child : placeholder,
        );
      },
    );
  }
}

