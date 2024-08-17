import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// app 激活挂起监听
// class AppLifecycleService {
//   final AsyncCallback onResume;
//   final AsyncCallback onInactive;
//   final AsyncCallback onPause;
//   final AsyncCallback onDetached;
//
//   AppLifecycleService({
//     required this.onResume,
//     required this.onInactive,
//     required this.onPause,
//     required this.onDetached,
//   }) {
//     SystemChannels.lifecycle.setMessageHandler((msg) async {
//       debugPrint('APP状态监听：$msg');
//       switch (msg) {
//         case "AppLifecycleState.resumed":
//           await onResume();
//           break;
//         case "AppLifecycleState.paused":
//           await onPause();
//           break;
//         case "AppLifecycleState.inactive":
//           await onInactive();
//           break;
//         case "AppLifecycleState.detached":
//           await onDetached();
//           break;
//         default:
//           break;
//       }
//     });
//   }
// }
