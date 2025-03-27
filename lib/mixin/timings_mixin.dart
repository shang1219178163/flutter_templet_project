//
//  TimingsMixin.dart
//  yl_patient_app
//
//  Created by shang on 2024/6/12 11:12.
//  Copyright © 2024/6/12 shang. All rights reserved.
//


import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';

/// fps
mixin TimingsMixin<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addTimingsCallback(onTimings);
  }

  @override
  void dispose() {
    SchedulerBinding.instance.removeTimingsCallback(onTimings);
    super.dispose();
  }

  void onTimings(List<FrameTiming> timings) {
    throw UnimplementedError(
        "❌: $this 未实现 onTimings(List<FrameTiming> timings)");
  }
}
