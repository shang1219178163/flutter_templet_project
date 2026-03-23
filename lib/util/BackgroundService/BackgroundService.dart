import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

// background_service.dart
class BackgroundService {
  static final service = FlutterBackgroundService();

  static Future<void> initialize() async {
    await service.configure(
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: onStart,
        onBackground: onIosBackground,
      ),
      androidConfiguration: AndroidConfiguration(
        autoStart: true,
        onStart: onStart,
        isForegroundMode: false,
        autoStartOnBoot: true,
      ),
    );
  }

  static void start() {
    service.startService();
  }

  static void stop() {
    service.invoke("stop");
  }

  static void syncNow() {
    service.invoke("syncNow");
  }
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  // DartPluginRegistrant.ensureInitialized();

  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) {
  // 监听停止
  service.on('stop').listen((event) {
    service.stopSelf();
  });

  // 监听同步触发
  service.on('syncNow').listen((event) async {
    await _performSync(manual: true);
  });

  // 定时检查（每30分钟）
  Timer.periodic(Duration(minutes: 30), (timer) async {
    await _performSync(manual: false);
  });
}

Future<void> _performSync({required bool manual}) async {
  try {
    // // 检查网络
    // if (!await _hasNetwork()) {
    //   debugPrint("无网络，跳过同步");
    //   return;
    // }

    // // 检查电量（非手动同步时）
    // if (!manual && await _isLowBattery()) {
    //   debugPrint("电量低，跳过自动同步");
    //   return;
    // }

    // 执行实际同步
    debugPrint("开始同步数据...");
    // await DataSyncHelper.syncAll();
    debugPrint("同步完成");

    // 记录最后同步时间
    await SharedPreferences.getInstance().then((prefs) {
      prefs.setString('last_sync', DateTime.now().toIso8601String());
    });
  } catch (e) {
    debugPrint("同步失败: $e");
  }
}
