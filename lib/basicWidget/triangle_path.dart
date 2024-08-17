//
//  TrianglePath.dart
//  flutter_templet_project
//
//  Created by shang on 12/15/21 6:47 PM.
//  Copyright © 12/15/21 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';

class TrianglePath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
