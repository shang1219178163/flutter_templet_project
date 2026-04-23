//
//  KeyboardAccessoryController.dart
//  flutter_templet_project
//
//  Created by shang on 2026/4/22 17:58.
//  Copyright © 2026/4/22 shang. All rights reserved.
//

import 'package:flutter/material.dart';

class KeyboardAccessoryController {
  OverlayEntry? _entry;
  OverlayEntry? get entry => _entry;

  void show(BuildContext context, Widget child) {
    if (_entry != null) {
      debugPrint("_entry != null");
      return;
    }

    _entry = OverlayEntry(
      builder: (ctx) {
        final bottom = MediaQuery.of(ctx).viewInsets.bottom;

        return AnimatedPositioned(
          duration: Duration(milliseconds: 300),
          left: 0,
          right: 0,
          bottom: bottom,
          child: Material(
            elevation: 4,
            color: Colors.green,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: bottom > 0 ? 50 : 0,
              child: child,
            ),
          ),
        );
      },
    );

    Overlay.of(context, rootOverlay: true).insert(_entry!);
  }

  void hide() {
    _entry?.remove();
    _entry = null;
  }
}
