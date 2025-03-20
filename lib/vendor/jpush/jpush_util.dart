//
//  JpushUtil.dart
//  flutter_templet_project
//
//  Created by shang on 2025/1/10 11:40.
//  Copyright © 2025/1/10 shang. All rights reserved.
//

/// 极光推送相关文件
class JPushUtil {
  static String appKey = "*";

  static String channel = "即时消息通道";

  static String channelId = "*";

  // static JPush _jPush = JPush();
  //
  // static JPush get jPush => _jPush;
  //
  // static set jPushInfo(JPush jPushInfo) {
  //   _jPush = jPushInfo;
  // }
  //
  // static clearNotification() {
  //   jPush.clearAllNotifications();
  // }
  //
  // /// 创建 Android 平台下的 `NotificationChannel`
  // static void createNotificationChannel(JPush jpush) {
  //   // xiaomi
  //   jpush.setChannelAndSound(
  //     channel: '会话即时消息',
  //     channelID: '110108',
  //   );
  //   jpush.setChannelAndSound(
  //     channel: '音视频消息',
  //     channelID: '114566',
  //     sound: 'wait_calling',
  //   );
  //   // oppo
  //   jpush.setChannelAndSound(
  //     channel: '即时消息通道',
  //     channelID: 'yltd2023080301',
  //   );
  // }
}
