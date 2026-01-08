//
//  ListFooterNoMorePlacehorlder.dart
//  flutter_templet_project
//
//  Created by shang on 2026/1/7 15:23.
//  Copyright © 2026/1/7 shang. All rights reserved.
//

import 'package:flutter/material.dart';

/// 列表没有更多数据占位图
class ListFooterNoMorePlacehorlder extends StatelessWidget {
  const ListFooterNoMorePlacehorlder({
    super.key,
    this.child,
  });

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 150, vertical: 16),
      decoration: BoxDecoration(
          // color: Colors.green,
          // border: Border.all(color: Colors.blue),
          ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Divider(color: Colors.black38, height: 1),
          ),
          child ??
              Container(
                width: 2,
                height: 2,
                margin: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.all(Radius.circular(1)),
                ),
              ),
          Expanded(
            child: Divider(color: Colors.black38, height: 1),
          ),
        ],
      ),
    );
  }
}
