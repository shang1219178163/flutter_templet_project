//
//  GetUtil.dart
//  flutter_templet_project
//
//  Created by shang on 2024/10/10 17:42.
//  Copyright © 2024/10/10 shang. All rights reserved.
//

import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/APPThemeSettings.dart';
import 'package:flutter_templet_project/basicWidget/n_footer_button_bar.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/basicWidget/n_textfield.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';
import 'package:flutter_templet_project/util/color_util.dart';
import 'package:get/get.dart';

/// Get.bottomSheet 封装类
class GetBottomSheet {
  /// 弹框 - 自定义child
  static Future<dynamic> showCustom({
    bool enableDrag = true,
    bool addUnconstrainedBox = true,
    bool hideDragIndicator = true,
    bool isScrollControlled = false, //控制高度
    required Widget child,
  }) {
    if (!hideDragIndicator) {
      child = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 3,
            color: const Color(0xffE5E5E5),
          ),
          Flexible(child: child),
        ],
      );
    }

    Widget content = Container(
      clipBehavior: Clip.hardEdge,
      width: Get.width,
      decoration: const BoxDecoration(
        color: white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: child,
    );

    if (addUnconstrainedBox) {
      content = UnconstrainedBox(
        child: content,
      );
    }

    return Get.bottomSheet(
      content,
      enableDrag: enableDrag,
      useRootNavigator: true,
      isScrollControlled: isScrollControlled,
    );
  }

  /// 底部展示菜单
  ///
  /// actions 每项点击事件及视图 ({VoidCallback onTap, Widget child}
  static void showActions<T extends ({VoidCallback onTap, Widget child})>({
    bool enableDrag = true,
    bool addUnconstrainedBox = true,
    required List<T> actions,
    VoidCallback? onCancel,
  }) {
    if (actions.isEmpty) {
      return;
    }

    GetBottomSheet.showCustom(
      enableDrag: enableDrag,
      addUnconstrainedBox: addUnconstrainedBox,
      child: NBottomSheet(
        actions: actions,
        onCancel: onCancel,
      ),
    );
  }

  /// 输入框弹窗
  ///
  /// controller 输入框控制器
  /// lengthLimit 字数限制,默认 200
  /// textFieldPadding textField边距
  /// onCancel 取消回调
  /// onConfirm 确定回调
  /// header 输入框上面
  /// middle 输入框下面
  /// footer 取消和确定按钮下面
  static Future<dynamic> showInput({
    required TextEditingController controller,
    String title = "编辑原因",
    int lengthLimit = 200,
    EdgeInsets textFieldPadding = const EdgeInsets.only(
      top: 20,
      left: 15,
      right: 15,
      bottom: 12,
    ),
    VoidCallback? onCancel,
    required VoidCallback? onConfirm,
    Widget? header,
    Widget? middle,
    Widget? footer,
  }) {
    final context = Get.context;
    final primary = context?.primaryColor ?? Colors.transparent;

    return showCustom(
      addUnconstrainedBox: false,
      child: NBottomInputBox(
        controller: controller,
        title: title,
        lengthLimit: 200,
        textFieldPadding: textFieldPadding,
        onCancel: onCancel,
        onConfirm: onConfirm,
        header: header,
        middle: middle,
        footer: footer,
      ),
    );
  }
}

class GetDialog {
  /// 弹框 - 自定义child
  static Future<dynamic> showCustom({
    bool enableDrag = false,
    bool needUnconstrainedBox = false,
    BoxConstraints? constraints,
    BoxDecoration? decoration,
    Widget? header,
    Widget? footer,
    required Widget child,
  }) {
    Widget content = Align(
      alignment: Alignment.center,
      child: Container(
        clipBehavior: Clip.hardEdge,
        margin: EdgeInsets.symmetric(horizontal: 30),
        constraints: constraints ?? BoxConstraints(maxHeight: 550, minHeight: 150),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            header ?? SizedBox(),
            Flexible(
              child: Scrollbar(
                child: SingleChildScrollView(
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    alignment: Alignment.center,
                    decoration: decoration ??
                        const BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                    child: child,
                  ),
                ),
              ),
            ),
            footer ?? SizedBox(),
          ],
        ),
      ),
    );
    if (needUnconstrainedBox) {
      content = UnconstrainedBox(
        child: content,
      );
    }
    return Get.dialog(
      content,
      barrierDismissible: false,
    );
  }

  static Future<dynamic> showConfirm({
    required String title,
    required String message,
    bool hideCancel = false,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) async {
    return GetDialog.showCustom(
      header: Container(
        height: 44,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border(
            bottom: BorderSide(width: .5, color: Color(0xffE5E5E5)),
          ),
        ),
        child: NavigationToolbar(
          middle: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ),
      footer: NFooterButtonBar(
        hideCancel: hideCancel,
        onCancel: onCancel ??
            () {
              Get.back();
            },
        onConfirm: onConfirm ??
            () {
              Get.back();
            },
      ),
      child: Text(
        message,
        style: TextStyle(fontWeight: FontWeight.w400),
      ),
    );
  }

  /// 输入框弹窗
  ///
  /// controller 输入框控制器
  /// lengthLimit 字数限制,默认 200
  /// textFieldPadding textField边距
  /// onCancel 取消回调
  /// onConfirm 确定回调
  /// header 输入框上面
  /// middle 输入框下面
  /// footer 取消和确定按钮下面
  static Future<dynamic> showInput({
    BoxConstraints? constraints,
    required TextEditingController controller,
    String title = "编辑原因",
    int lengthLimit = 200,
    EdgeInsets textFieldPadding = const EdgeInsets.only(
      top: 20,
      left: 15,
      right: 15,
      bottom: 12,
    ),
    VoidCallback? onCancel,
    required VoidCallback? onConfirm,
    Widget? header,
    Widget? middle,
    Widget? footer,
  }) {
    final context = Get.context;
    final primary = context?.primaryColor ?? Colors.transparent;

    return showCustom(
      constraints: constraints,
      enableDrag: false,
      child: NBottomInputBox(
        controller: controller,
        title: title,
        lengthLimit: 200,
        textFieldPadding: textFieldPadding,
        onCancel: onCancel,
        onConfirm: onConfirm,
        dragIndicator: SizedBox(),
        header: header,
        middle: middle,
        footer: footer,
      ),
    );
  }
}

/// 底部弹窗列表
class NBottomSheet<T extends ({VoidCallback onTap, Widget child})> extends StatelessWidget {
  const NBottomSheet({
    super.key,
    required this.actions,
    this.onCancel,
  });

  final List<T> actions;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...actions
                .map((e) => buildActionCell(
                      onTap: e.onTap,
                      hasDivider: e != actions.first,
                      child: e.child,
                    ))
                .toList(),
            Container(height: 8, color: bgColor),
            buildActionCancel(
              onTap: onCancel ?? () => Navigator.of(context).maybePop(),
            ),
            SizedBox(height: Platform.isIOS ? 34 : 8),
          ],
        ),
      ),
    );
  }

  /// 展示菜单子项
  ///
  /// hasDivider 是否显示分割线
  /// onTap 点击回调
  /// child 子组件
  Widget buildActionCell({
    bool hasDivider = true,
    required Widget child,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasDivider) const Divider(height: 0.5, color: lineColor),
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            // color: ColorExt.random,
            padding: EdgeInsets.symmetric(vertical: 12),
            child: child,
          ),
        ],
      ),
    );
  }

  /// 展示菜单取消项
  ///
  /// onTap 点击回调
  /// child 自定义内容
  Widget buildActionCancel({
    required VoidCallback onTap,
    Widget? child,
  }) {
    return buildActionCell(
      onTap: onTap,
      child: child ?? const NText('取消'),
    );
  }
}

/// 弹窗内容显示组件
class NDialogBox extends StatelessWidget {
  const NDialogBox({
    super.key,
    required this.context,
    this.padding,
    this.title,
    this.titleWidget,
    this.message,
    this.messageWidget,
    this.messagePadding = const EdgeInsets.symmetric(vertical: 16),
    this.bottomWidget,
    this.onCancel,
    this.onConfirm,
  });

  final BuildContext context;

  /// 内边距
  final EdgeInsets? padding;

  /// 标题
  final String? title;

  /// 内容组件
  final Widget? titleWidget;

  /// 内容
  final String? message;

  /// 内容组件
  final Widget? messageWidget;

  final EdgeInsets? messagePadding;

  /// 按钮组件
  final Widget? bottomWidget;

  /// 取消
  final VoidCallback? onCancel;

  /// 确定
  final VoidCallback? onConfirm;

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context).extension<NAppTheme>();
    final fontColor = appTheme?.fontColor;

    final dialogTheme = Theme.of(context).extension<NDialogTheme>();

    return Container(
      width: dialogTheme?.width ?? 315,
      clipBehavior: Clip.hardEdge,
      alignment: Alignment.center,
      padding: padding ?? dialogTheme?.padding ?? const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(dialogTheme?.raidus ?? 16),
      ),
      child: Column(
        children: [
          titleWidget ??
              NText(
                title ?? "",
                textAlign: TextAlign.center,
                style: appTheme?.titleStyle,
              ),
          Flexible(
            child: Container(
              padding: messagePadding,
              child: Scrollbar(
                child: SingleChildScrollView(
                  child: Container(
                    alignment: Alignment.center,
                    child: messageWidget ??
                        NText(
                          message ?? "",
                          color: fontColor,
                          // textAlign: TextAlign.center,
                          style: appTheme?.textStyle,
                        ),
                  ),
                ),
              ),
            ),
          ),
          bottomWidget ??
              NFooterButtonBar(
                padding: EdgeInsets.zero,
                gap: 16,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                onCancel: onCancel,
                onConfirm: onConfirm,
              ),
        ],
      ),
    );
  }
}

/// 输入框带取消确认按钮
class NBottomInputBox extends StatelessWidget {
  const NBottomInputBox({
    super.key,
    required this.controller,
    this.title = "编辑原因",
    this.lengthLimit = 200,
    this.textFieldPadding = const EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 12),
    this.onCancel,
    required this.onConfirm,
    this.dragIndicator,
    this.header,
    this.middle,
    this.footer,
  });

  final TextEditingController controller;
  final String title;
  final int lengthLimit;
  final EdgeInsets textFieldPadding;
  final VoidCallback? onCancel;
  final VoidCallback? onConfirm;
  final Widget? dragIndicator;
  final Widget? header;
  final Widget? middle;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    return ColoredBox(
      color: white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 8),
          dragIndicator ??
              Padding(
                padding: const EdgeInsets.only(bottom: 13),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 3,
                      decoration: BoxDecoration(
                        color: lineColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: fontColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
          header ?? const SizedBox(),
          Container(
            padding: textFieldPadding,
            constraints: const BoxConstraints(minHeight: 82),
            child: Column(
              children: [
                NTextField(
                  controller: controller,
                  hintText: '请输入...',
                  hintStyle: TextStyle(fontSize: 14, color: fontColor),
                  minLines: 5,
                  maxLines: 10,
                  autofocus: true,
                  fillColor: Colors.white,
                  radius: 8,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(lengthLimit),
                  ],
                  onChanged: (String value) {},
                  onSubmitted: (String value) {},
                ),
              ],
            ),
          ),
          middle ?? const SizedBox(),
          NFooterButtonBar(
            confirmTitle: "提交",
            padding: EdgeInsets.only(
              top: 0,
              left: 16,
              right: 16,
              // bottom: max(12, MediaQuery.of(context).padding.bottom),
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              // border: Border(
              //   top: BorderSide(width: 0.5, color: Color(0xffE5E5E5)),
              // ),
            ),
            onCancel: onCancel,
            onConfirm: onConfirm,
          ).toColoredBox(),
          footer ?? const SizedBox(),
          SizedBox(
            height: max(12, MediaQuery.of(context).padding.bottom),
          ),
        ],
      ),
    );
  }
}
