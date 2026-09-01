//
//  LocalAuthDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2025/8/20 20:42.
//  Copyright © 2025/8/20 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/basicWidget/button/n_button.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_switch_list_tile.dart';
import 'package:flutter_templet_project/basicWidget/list_tile/n_text_field_list_item.dart';
import 'package:flutter_templet_project/basicWidget/n_decoration_card.dart';
import 'package:flutter_templet_project/basicWidget/n_description_card.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:flutter_templet_project/util/snack_util.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';
import 'package:local_auth_windows/local_auth_windows.dart';

/// 生物识别技术（例如指纹或面部识别） https://pub.dev/packages/local_auth
class LocalAuthDemo extends StatefulWidget {
  const LocalAuthDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<LocalAuthDemo> createState() => _LocalAuthDemoState();
}

class _LocalAuthDemoState extends State<LocalAuthDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());
  late final theme = Theme.of(context);

  final scrollController = ScrollController();
  final reasonController = TextEditingController(text: '请验证身份以继续');
  final cancelController = TextEditingController();
  final fallbackController = TextEditingController();
  final signInTitleController = TextEditingController();
  final biometricHintController = TextEditingController();

  Map<String, dynamic> arguments = Get.arguments ?? <String, dynamic>{};

  /// id
  late final id = arguments["id"];

  final auth = LocalAuthentication();

  /// 失败时弹出系统错误对话框
  bool useErrorDialogs = true;
  /// 应用切后台后保持认证
  bool stickyAuth = false;
  /// 敏感交易（平台可能加强校验）
  bool sensitiveTransaction = true;
  /// 仅生物识别，不用设备密码
  bool biometricOnly = false;
  /// 是否自定义平台文案
  bool useCustomMessages = false;
  /// 认证进行中
  bool busy = false;
  /// 设备是否支持
  bool? isDeviceSupported;
  /// 是否可检测生物识别
  bool? canCheckBiometrics;
  /// 可用生物识别类型
  List<BiometricType> availableBiometrics = [];
  /// 最近事件
  String lastEvent = '—';

  @override
  void dispose() {
    scrollController.dispose();
    reasonController.dispose();
    cancelController.dispose();
    fallbackController.dispose();
    signInTitleController.dispose();
    biometricHintController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = theme.colorScheme;
    return Scaffold(
      backgroundColor: scheme.surfaceContainerLowest,
      appBar: hideApp
          ? null
          : AppBar(
              title: Text("$widget"),
              actions: [
                TextButton(
                  onPressed: onReset,
                  child: Text('重置', style: TextStyle(color: scheme.onPrimary)),
                ),
              ],
            ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    final scheme = theme.colorScheme;
    return ColoredBox(
      color: scheme.surfaceContainerLowest,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final previewHeight = (constraints.maxHeight * 0.42).clamp(240.0, 360.0);
          return Column(
            children: [
              buildPreview(previewHeight),
              Expanded(
                child: Scrollbar(
                  controller: scrollController,
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Column(
                      children: [
                        const NDescriptionCard(
                          initialLang: NLangEnum.zh,
                          title: {
                            NLangEnum.en: 'Description',
                            NLangEnum.zh: '说明',
                          },
                          subtitle: {
                            NLangEnum.en: 'Plugin local_auth',
                            NLangEnum.zh: '插件 local_auth',
                          },
                          items: [
                            {
                              NLangEnum.en:
                                  'Original “开始” only checks device / biometrics. Tune AuthenticationOptions and localizedReason, then authenticate or stopAuthentication. Simulator often throws PlatformException (otherOperatingSystem).',
                              NLangEnum.zh:
                                  '原 Demo「开始」只检测设备与生物识别能力。调节 AuthenticationOptions、localizedReason 后调用 authenticate / stopAuthentication。模拟器常抛 PlatformException（otherOperatingSystem）。',
                            },
                          ],
                        ),
                        buildAuthCard(),
                        buildMessagesCard(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildPreview(double previewHeight) {
    final scheme = theme.colorScheme;
    final types = availableBiometrics.isEmpty ? '—' : availableBiometrics.map((e) => e.name).join(', ');
    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.35),
        border: Border(
          bottom: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.65)),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: previewHeight,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    [
                      'isDeviceSupported: ${isDeviceSupported ?? '—'}',
                      'canCheckBiometrics: ${canCheckBiometrics ?? '—'}',
                      'availableBiometrics: $types',
                    ].join('\n'),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurface,
                      fontFamily: 'monospace',
                      height: 1.5,
                    ),
                  ),
                  const Spacer(),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      NButton(
                        onPressed: busy ? null : onStart,
                        child: const Text('开始'),
                      ),
                      FilledButton.tonal(
                        onPressed: busy ? null : onAuthenticate,
                        child: const Text('认证'),
                      ),
                      OutlinedButton(
                        onPressed: busy ? null : onStop,
                        child: const Text('停止'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Text(
              lastEvent,
              textAlign: TextAlign.center,
              style: theme.textTheme.labelMedium?.copyWith(
                color: scheme.onSurfaceVariant,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAuthCard() {
    return NDecorationCard(
      icon: const Icon(Icons.fingerprint_rounded),
      title: '认证',
      subtitle: 'localizedReason  AuthenticationOptions',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NTextFieldListItem(
            title: const Text('localizedReason'),
            controller: reasonController,
            onChanged: (v) => onMark('localizedReason $v'),
          ),
          NSwitchListTile(
            title: const Text('useErrorDialogs'),
            value: useErrorDialogs,
            onChanged: (v) => onMark('useErrorDialogs $v', () => useErrorDialogs = v),
          ),
          NSwitchListTile(
            title: const Text('stickyAuth'),
            value: stickyAuth,
            onChanged: (v) => onMark('stickyAuth $v', () => stickyAuth = v),
          ),
          NSwitchListTile(
            title: const Text('sensitiveTransaction'),
            value: sensitiveTransaction,
            onChanged: (v) => onMark('sensitiveTransaction $v', () => sensitiveTransaction = v),
          ),
          NSwitchListTile(
            title: const Text('biometricOnly'),
            value: biometricOnly,
            onChanged: (v) => onMark('biometricOnly $v', () => biometricOnly = v),
          ),
        ],
      ),
    );
  }

  Widget buildMessagesCard() {
    return NDecorationCard(
      icon: const Icon(Icons.message_outlined),
      title: '对话框文案',
      subtitle: 'authMessages',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NSwitchListTile(
            title: const Text('authMessages 自定义'),
            value: useCustomMessages,
            onChanged: (v) => onMark('authMessages ${v ? 'custom' : 'default'}', () => useCustomMessages = v),
          ),
          if (useCustomMessages) ...[
            NTextFieldListItem(
              title: const Text('cancelButton'),
              showTopGap: true,
              controller: cancelController,
              hintText: '默',
              onChanged: (v) => onMark('cancelButton $v'),
            ),
            NTextFieldListItem(
              title: const Text('IOSAuthMessages.localizedFallbackTitle'),
              showTopGap: true,
              controller: fallbackController,
              hintText: '默',
              onChanged: (v) => onMark('localizedFallbackTitle $v'),
            ),
            NTextFieldListItem(
              title: const Text('AndroidAuthMessages.signInTitle'),
              showTopGap: true,
              controller: signInTitleController,
              hintText: '默',
              onChanged: (v) => onMark('signInTitle $v'),
            ),
            NTextFieldListItem(
              title: const Text('AndroidAuthMessages.biometricHint'),
              showTopGap: true,
              controller: biometricHintController,
              hintText: '默',
              onChanged: (v) => onMark('biometricHint $v'),
            ),
          ],
        ],
      ),
    );
  }

  Iterable<AuthMessages> buildAuthMessages() {
    if (!useCustomMessages) {
      return const <AuthMessages>[
        IOSAuthMessages(),
        AndroidAuthMessages(),
        WindowsAuthMessages(),
      ];
    }
    final cancel = emptyToNull(cancelController.text);
    return [
      IOSAuthMessages(
        cancelButton: cancel,
        localizedFallbackTitle: emptyToNull(fallbackController.text),
      ),
      AndroidAuthMessages(
        cancelButton: cancel,
        signInTitle: emptyToNull(signInTitleController.text),
        biometricHint: emptyToNull(biometricHintController.text),
      ),
      const WindowsAuthMessages(),
    ];
  }

  AuthenticationOptions buildOptions() {
    return AuthenticationOptions(
      useErrorDialogs: useErrorDialogs,
      stickyAuth: stickyAuth,
      sensitiveTransaction: sensitiveTransaction,
      biometricOnly: biometricOnly,
    );
  }

  String? emptyToNull(String value) {
    final text = value.trim();
    if (text.isEmpty) {
      return null;
    }
    return text;
  }

  Future<void> onStart() async {
    busy = true;
    setState(() {});
    try {
      final supported = await auth.isDeviceSupported();
      isDeviceSupported = supported;
      if (!supported) {
        lastEvent = 'isDeviceSupported false';
        DLog.d('设备不支持');
        SnackUtil.show(lastEvent);
        return;
      }
      final canBio = await auth.canCheckBiometrics;
      canCheckBiometrics = canBio;
      if (!canBio) {
        lastEvent = 'canCheckBiometrics false';
        DLog.d('设备不支持1');
        SnackUtil.show(lastEvent);
        return;
      }
      final types = await auth.getAvailableBiometrics();
      availableBiometrics = types;
      if (types.isEmpty) {
        lastEvent = 'availableBiometrics empty';
        DLog.d('不可用');
        SnackUtil.show(lastEvent);
        return;
      }
      lastEvent = 'availableBiometrics: ${types.map((e) => e.name).join(', ')}';
      DLog.d(lastEvent);
      SnackUtil.show(lastEvent);
    } on PlatformException catch (e) {
      lastEvent = 'onStart ${e.code} ${e.message}';
      DLog.d(lastEvent);
      SnackUtil.show(lastEvent);
    } finally {
      busy = false;
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future<void> onAuthenticate() async {
    final reason = reasonController.text.trim();
    if (reason.isEmpty) {
      lastEvent = 'localizedReason 不能为空';
      SnackUtil.show(lastEvent);
      setState(() {});
      return;
    }
    busy = true;
    setState(() {});
    try {
      final ok = await auth.authenticate(
        localizedReason: reason,
        authMessages: buildAuthMessages(),
        options: buildOptions(),
      );
      lastEvent = 'authenticate $ok';
      DLog.d(lastEvent);
      SnackUtil.show(lastEvent);
    } on PlatformException catch (e) {
      lastEvent = 'authenticate ${e.code} ${e.message}';
      DLog.d(lastEvent);
      SnackUtil.show(lastEvent);
    } finally {
      busy = false;
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future<void> onStop() async {
    busy = true;
    setState(() {});
    try {
      final ok = await auth.stopAuthentication();
      lastEvent = 'stopAuthentication $ok';
      DLog.d(lastEvent);
      SnackUtil.show(lastEvent);
    } on PlatformException catch (e) {
      lastEvent = 'stopAuthentication ${e.code} ${e.message}';
      DLog.d(lastEvent);
      SnackUtil.show(lastEvent);
    } finally {
      busy = false;
      if (mounted) {
        setState(() {});
      }
    }
  }

  void onMark(String event, [VoidCallback? apply]) {
    apply?.call();
    lastEvent = event;
    setState(() {});
  }

  void onReset() {
    reasonController.text = '请验证身份以继续';
    cancelController.clear();
    fallbackController.clear();
    signInTitleController.clear();
    biometricHintController.clear();
    useErrorDialogs = true;
    stickyAuth = false;
    sensitiveTransaction = true;
    biometricOnly = false;
    useCustomMessages = false;
    busy = false;
    isDeviceSupported = null;
    canCheckBiometrics = null;
    availableBiometrics = [];
    lastEvent = '—';
    setState(() {});
  }
}
