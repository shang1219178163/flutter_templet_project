import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/routes/AppRouter.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:flutter_templet_project/util/theme/theme_provider.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

/// 聊天设置页面
class ImChatSettingPage extends StatefulWidget {
  const ImChatSettingPage({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<ImChatSettingPage> createState() => _ImChatSettingPageState();
}

class _ImChatSettingPageState extends State<ImChatSettingPage> {
  late final args = Get.arguments ?? widget.arguments ?? <String, dynamic>{};

  bool isIgnore = false;
  bool isPined = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future init() async {}

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.read<ThemeProvider>();

    return Scaffold(
      backgroundColor: themeProvider.color181829OrF6F6F6,
      appBar: AppBar(
        title: Text("聊天设置"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            margin: const EdgeInsets.only(top: 11),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(4)),
            ),
            child: Column(
              children: [
                buildItem(
                  margin: const EdgeInsets.only(top: 0),
                  title: "消息免打扰",
                  trailing: CupertinoSwitch(
                    value: isIgnore,
                    onChanged: (value) {
                      isIgnore = value;
                      setState(() {});
                    },
                  ),
                ),
                Divider(height: 0.5),
                buildItem(
                  margin: const EdgeInsets.only(top: 0),
                  title: "消息置顶",
                  trailing: CupertinoSwitch(
                    value: isPined,
                    onChanged: (value) {
                      isPined = value;
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
          ),
          buildItem(
            margin: const EdgeInsets.only(top: 16),
            title: "清空聊天记录",
            onTap: () {
              DLog.d(args);
            },
          ),
          buildItem(
            margin: const EdgeInsets.only(top: 16),
            title: "投诉",
            onTap: () {
              DLog.d(args);
            },
          ),
          buildItem(
            margin: const EdgeInsets.only(top: 16),
            title: "设置聊天气泡",
            onTap: () {
              DLog.d(args);
              Get.toNamed(AppRouter.imChatBubbleChange, arguments: args);
            },
          ),
        ],
      ),
    );
  }

  Widget buildItem({
    EdgeInsets? margin,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    late final themeProvider = context.read<ThemeProvider>();
    return Container(
      padding: margin,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            color: themeProvider.itemBgColor,
          ),
          padding: const EdgeInsets.only(left: 8, right: 8),
          height: 48,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
              ),
              const Spacer(),
              trailing ??
                  Icon(
                    Icons.arrow_forward_ios,
                    color: themeProvider.arrowColor,
                    size: 16,
                  )
            ],
          ),
        ),
      ),
    );
  }
}
