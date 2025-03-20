import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/basicWidget/n_app_bar.dart';
import 'package:flutter_templet_project/basicWidget/n_future_builder.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/cache/cache_service.dart';
import 'package:flutter_templet_project/cache/file_manager.dart';
import 'package:flutter_templet_project/extension/service_protocol_info_ext.dart';
import 'package:flutter_templet_project/mixin/debug_bottom_sheet_mixin.dart';
import 'package:flutter_templet_project/network/RequestConfig.dart';
import 'package:flutter_templet_project/routes/APPRouter.dart';
import 'package:flutter_templet_project/util/tts_manager.dart';
import 'package:flutter_templet_project/vendor/isar/DBManager.dart';
import 'package:get/get.dart';

/// 极光推送相关信息页面
class JPushInfoPage extends StatefulWidget {
  const JPushInfoPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _JPushInfoPageState createState() => _JPushInfoPageState();
}

class _JPushInfoPageState extends State<JPushInfoPage> with DebugBottomSheetMixin {
  late final items = [
    "名称: ${CacheService().appName}",
    "版本: ${'v${CacheService().appVersion}.${CacheService().appVersionCode}'}",
    "环境: ${RequestConfig.current.name}",
    "域名: ${RequestConfig.baseUrl}",
    "loginId: ${CacheService().loginAccount}",
    "userID: ${CacheService().userID}",
    // "imAccount: ${CacheService().imAccount}",
    "rid: ${CacheService().getString(CacheKey.registrationId.name)}",
    "LAST_PUSH: ${CacheService().getString(CacheKey.lastJPush.name)}",
    "tts error: ${TTSManager().exception}",
    "DBManager error: ${DBManager().exception}",
    "request error: ${CacheService().getString(CacheKey.lastRequestError.name)}",
  ];

  final jpushStatusInfoVN = ValueNotifier("");

  List<({String title, VoidCallback action})> get records => [
        (title: "返回登录页", action: onLoginPage),
        (title: "解绑手机", action: onUnbindPhone),
        (title: "清除账号列表", action: onClearAccount),
        (title: "查看操作日志", action: onOperateLog),
        (title: "清除操作日志", action: onOperateLogClear),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NAppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: buildBody(),
    );
  }

  buildBody() {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: records.map((e) {
                return ElevatedButton(
                  style: TextButton.styleFrom(
                    // padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    minimumSize: const Size(24, 28),
                    // foregroundColor: Colors.blue,
                  ),
                  onPressed: e.action,
                  child: Text(e.title),
                );
              }).toList(),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.blue),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const NText("isar 链接", fontWeight: FontWeight.w500),
                  NFutureBuilder<ServiceProtocolInfo>(
                    future: Service.getInfo(),
                    loadingBuilder: () => const NText("isar 链接获取中..."),
                    builder: (data) {
                      final isarUrl = data.getIsarUrl(isCommunityVersion: true);
                      if (isarUrl == null) {
                        return const NText("isar 链接获取失败");
                      }
                      return Row(
                        children: [
                          Expanded(
                            child: SelectableText(isarUrl),
                          ),
                          OutlinedButton(
                            onPressed: () {
                              // 将文本复制到剪切板
                              _copyToClipboard(isarUrl ?? "");
                            },
                            child: const Text("复制"),
                          ),
                        ],
                      );
                    },
                  ),
                  const Divider(),
                ],
              ),
            ),
            ...items
                .map((e) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: SelectableText(e),
                        ),
                        const Divider(height: 1),
                      ],
                    ))
                .toList(),
            ValueListenableBuilder(
              valueListenable: jpushStatusInfoVN,
              builder: (context, value, child) {
                return SelectableText(value);
              },
            ),
          ],
        ),
      ),
    );
  }

  void onLoginPage() {
    Get.toNamed(APPRouter.loginPage);
  }

  onUnbindPhone() async {
    await requestUnbindPhone();
  }

  requestUnbindPhone() async {}

  onClearAccount() async {
    await FileManager().saveJson(fileName: "CACHE_ACCOUNT_List", map: {});
  }

  onOperateLog() async {
    onDebugBottomSheet(
      title: "操作日志",
      content: NFutureBuilder(
        future: CacheService().updateLogs(value: ""),
        loadingBuilder: () => const NText("本地操作日志获取中..."),
        builder: (data) {
          if (data.isNotEmpty != true) {
            return const Padding(
              padding: EdgeInsets.all(8.0),
              child: NText("本地操作日志获取失败", fontWeight: FontWeight.w500),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...data.entries.map((e) {
                final content = [e.value, e.key].join(" ");
                return NText(content, fontSize: 12);
              }).toList(),
            ],
          );
        },
      ),
    );
  }

  onOperateLogClear() {
    CacheService().remove(CacheKey.localOperateLog.name);
  }

  void _printIsarLink(String url) {
    String line(String text, String fill) {
      final fillCount = url.length - text.length;
      final left = List.filled(fillCount ~/ 2, fill);
      final right = List.filled(fillCount - left.length, fill);
      return left.join() + text + right.join();
    }

    debugPrint('╔${line('', '═')}╗');
    debugPrint('║${line('ISAR CONNECT STARTED', ' ')}║');
    debugPrint('╟${line('', '─')}╢');
    debugPrint('║${line('Open the link to connect to the Isar', ' ')}║');
    debugPrint('║${line('Inspector while this build is running.', ' ')}║');
    debugPrint('╟${line('', '─')}╢');
    debugPrint('║$url║');
    debugPrint('╚${line('', '═')}╝');
  }

  void _copyToClipboard(String text) {
    // 将文本复制到剪切板
    Clipboard.setData(ClipboardData(text: text)).then((_) {
      // 显示提示，告诉用户已复制
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('复制成功: $text')),
      );
      _printIsarLink(text);
      CacheService().updateLogs(value: "$runtimeType $text");
    });
  }
}
