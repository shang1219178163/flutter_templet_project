import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_footer_button_bar.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:get/get.dart';

/// 组件或者中间页
class ComponentMiddlePage extends StatefulWidget {
  ComponentMiddlePage({super.key, this.title});

  final String? title;

  @override
  State<ComponentMiddlePage> createState() => _ComponentMiddlePageState();
}

class _ComponentMiddlePageState extends State<ComponentMiddlePage> {
  /// 传参
  final Map<String, dynamic> arguments = Get.arguments ?? <String, dynamic>{};

  /// 可选按钮事件
  late final onSkip = arguments["onSkip"] as VoidCallback?;

  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: [
          'done',
        ]
            .map((e) => TextButton(
                  child: Text(
                    e,
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => debugPrint(e),
                ))
            .toList(),
      ),
      body: Column(
        children: [
          Expanded(
            child: buildList(),
          ),
          buildPageFooter(
            onConfirm: () {
              ddlog("onConfirm");
            },
          ),
        ],
      ),
    );
  }

  Widget buildList() {
    final items = List.generate(20, (index) => index);

    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: items.map((e) {
            return Column(
              children: [
                ListTile(
                  // contentPadding: EdgeInsets.zero,
                  // dense: true,
                  title: NText("row_$e"),
                ),
                Divider(),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget buildPageFooter({required VoidCallback onConfirm}) {
    return NFooterButtonBar(
      // primary: Colors.red,
      // decoration: const BoxDecoration(
      //     color: Colors.white,
      //     border: Border(
      //         top: BorderSide(color: Color(0xffE5E5E5))
      //     )
      // ),
      confirmTitle: "保存",
      enable: true,
      hideCancel: true,
      // isReverse: true,
      onConfirm: onConfirm,
      header: arguments["header"] ?? const SizedBox(),
      footer: onSkip == null
          ? const SizedBox()
          : InkWell(
              onTap: onSkip,
              child: Padding(
                padding: EdgeInsets.only(top: 12),
                child: NText(
                  "先跳过，稍后再提交",
                  color: context.primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
    );
  }
}
