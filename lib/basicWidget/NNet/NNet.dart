//
//  NNet.dart
//  flutter_templet_project
//
//  Created by shang on 3/30/23 9:46 AM.
//  Copyright © 3/30/23 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/service/connectivity_service.dart';

// enum NNetState{
//   /// show child
//   normal,
//   /// no data
//   empty,
//   /// net error
//   offline,
// }

/// 网络状态组件
class NNet extends StatefulWidget {

  NNet({
    Key? key,
    this.title,
    // required this.state,
    this.cachedChild,
    required this.childBuilder,
    required this.errorBuilder,
    this.emptyBuilder,

  }) : super(key: key);

  String? title;

  // ValueNotifier<NNetState> state;
  // bool isEmpty;

  Widget? cachedChild;

  TransitionBuilder childBuilder;

  TransitionBuilder errorBuilder;

  TransitionBuilder? emptyBuilder;

  @override
  _NNetState createState() => _NNetState();
}

class _NNetState extends State<NNet> {


  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: ConnectivityService().onLine,
      child: widget.cachedChild,
      builder: (context, value, child) {
        print('ValueListenableBuilder: ${value}');
        if (!value) {
          return widget.errorBuilder(context, child);
        }
        return widget.childBuilder(context, child);
      },
    );
  }

// @override
// Widget build(BuildContext context) {
//   return ValueListenableBuilder<NNetState>(
//     valueListenable: widget.state,
//     child: widget.cachedChild,
//     builder: (context, value, child) {
//       print('ValueListenableBuilder: ${value}');
//       if (value == NNetState.offline) {
//         return widget.offlineBuilder(context, child);
//       }
//
//       if (value == NNetState.empty) {
//         return widget.emptyBuilder?.call(context, child) ?? SizedBox();
//       }
//
//       return widget.childBuilder(context, child);
//     },
//   );
// }

}



