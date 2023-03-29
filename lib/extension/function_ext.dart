//
//  FunctionExt.dart
//  flutter_templet_project
//
//  Created by shang on 3/29/23 3:06 PM.
//  Copyright © 3/29/23 shang. All rights reserved.
//


extension FunctionExt on Function{
  /// 同 Function.apply
  static apply(
      Function function,
      List<dynamic>? positionalArguments,
      [Map<String, dynamic>? namedArguments]
  ) {
    final arguments = namedArguments?.map((key, value) => MapEntry(new Symbol("${key}"), value));
    return Function.apply(function, positionalArguments, arguments);
  }

}


