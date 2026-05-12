//
//  StreamExt.dart
//  flutter_templet_project
//
//  Created by shang on 2026/5/11 17:07.
//  Copyright © 2026/5/11 shang. All rights reserved.
//

import 'dart:async';

extension StreamExt<T> on Stream<T> {
  /// 新增 debounceTime
  Stream<T> debounceTime(Duration duration) {
    Timer? timer;
    StreamController<T>? controller;
    StreamSubscription<T>? subscription;

    controller = StreamController<T>(
      onListen: () {
        T? last;

        subscription = listen(
          (event) {
            last = event;

            timer?.cancel();
            timer = Timer(duration, () {
              if (last != null) {
                controller?.add(last as T);
              }
            });
          },
          onError: controller?.addError,
          onDone: () {
            timer?.cancel();
            controller?.close();
          },
          cancelOnError: false,
        );
      },
      onCancel: () async {
        timer?.cancel();
        await subscription?.cancel();
      },
    );

    return controller.stream;
  }
}
