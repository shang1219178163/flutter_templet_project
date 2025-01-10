//
//  DebugBottomSheetMixin.dart
//  projects
//
//  Created by shang on 2025/1/7 10:01.
//  Copyright © 2025/1/7 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Debug 底部弹窗封装
mixin DebugBottomSheetMixin<T extends StatefulWidget> on State<T> {
  /// 弹窗展示类型
  Future<R?> onDebugBottomSheet<R>({
    required String title,
    required Widget content,
    String confirmTitle = "确定",
    VoidCallback? onConfirm,
  }) {
    return Get.bottomSheet<R>(
      FractionallySizedBox(
        heightFactor: 0.7,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 50,
              child: NavigationToolbar(
                leading: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    child: const Text(
                      "取消",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15.0,
                        color: Color(0xff737373),
                      ),
                    ),
                  ),
                ),
                middle: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15.0,
                    color: Color(0xff181818),
                  ),
                  textAlign: TextAlign.center,
                ),
                trailing: InkWell(
                  onTap: onConfirm,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    child: Text(
                      confirmTitle,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Scrollbar(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                    child: content,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 34),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.white,
    );
  }
}
