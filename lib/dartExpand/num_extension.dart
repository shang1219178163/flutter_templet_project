//
//  NumExtension.dart
//  lib
//
//  Created by shang on 11/29/21 3:38 PM.
//  Copyright © 11/29/21 shang. All rights reserved.
//

import 'dart:math';

int randomInt({required int min, required int max}) {
  return min + Random().nextInt(max - min);
}



