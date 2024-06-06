import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/basicWidget/n_textfield.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/util/color_util.dart';
import 'package:get/get.dart';
import 'package:tuple/tuple.dart';

/// 自定义路由函数封装
extension GetRouteUtil on GetInterface {
  /// 堆栈路由跳转
  /// pageRoute 路由
  /// onBefore 跳转前回调函数
  /// onUntil 堆栈中查询到路由时回调方法, 为空执行 Get.until
  /// onJump 堆栈中没查询到路由时回调方法, 为空执行 Get.offNamed
  /// 返回值 是否在堆栈中查询到路由
  bool jump(
    String pageRoute, {
    dynamic arguments,
    VoidCallback? onBefore,
    VoidCallback? onJump,
    VoidCallback? onUntil,
  }) {
    final routes = Get.routeTree.routes.reversed;
    for (final route in routes) {
      if (route.name == pageRoute) {
        onBefore?.call();
        if (onUntil != null) {
          onUntil.call();
        } else {
          Get.until((route) => route.settings.name == pageRoute);
        }
        return true;
      }
    }

    onBefore?.call();
    if (onJump != null) {
      onJump.call();
    } else {
      Get.offNamed(pageRoute, arguments: arguments);
    }
    return false;
  }

  /// 当前路由堆栈是否包含此路由
  bool hasRoute(String routeName) {
    final routes = Get.routeTree.routes.reversed;
    for (final route in routes) {
      if (route.name == routeName) {
        return true;
      }
    }
    return false;
  }
}

/// Get.bottomSheet 封装类
class GetBottomSheet {
  /// 弹框 - 自定义child
  static void showCustom({
    Widget? child,
    bool enableDrag = false,
    bool needUnconstrainedBox = true,
  }) {
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
    if (needUnconstrainedBox) {
      content = UnconstrainedBox(
        child: content,
      );
    }
    Get.bottomSheet(content, enableDrag: enableDrag, isScrollControlled: true);
  }

  /// 底部展示菜单
  ///
  /// actions 每项点击事件及视图 ({VoidCallback onTap, Widget child}
  static void showActions<T extends ({VoidCallback onTap, Widget child})>({
    required List<T> actions,
    VoidCallback? onCancel,
  }) {
    if (actions.isEmpty) {
      return;
    }

    showCustom(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...actions
              .map((e) => buildActionCell(
                    onTap: e.onTap,
                    hasDivider: actions.indexOf(e) != 0,
                    child: e.child,
                  ))
              .toList(),
          Container(height: 8, color: bgColor),
          buildActionCancel(onTap: onCancel),
          SizedBox(height: Platform.isIOS ? 34 : 8),
        ],
      ),
    );
  }

  /// 弹框 - bottomSheet类型
  ///
  /// actions 数据
  /// onItem 回调参数
  static void showActionTitles({
    required List<String> actions,
    required Function(int) onItem,
  }) {
    showCustom(
      child: Column(
        children: [
          ...actions.map((e) {
            final i = actions.indexOf(e);

            return buildActionCell(
              onTap: () => onItem(i),
              child: NText(
                e,
                color: fontColor,
              ),
            );
          }).toList(),
          Container(height: 8, color: bgColor),
          buildActionCell(
            onTap: () => Get.back(),
            child: const NText(
              '取消',
              color: fontColor,
            ),
          ),
          SizedBox(height: Platform.isIOS ? 30 : 0),
        ],
      ),
    );
  }

  /// 展示菜单子项
  ///
  /// hasDivider 是否显示分割线
  /// onTap 点击回调
  /// child 子组件
  static Widget buildActionCell({
    bool hasDivider = true,
    required Widget child,
    required VoidCallback? onTap,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasDivider)
          const Divider(
            height: 1,
          ),
        InkWell(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            alignment: Alignment.center,
            // color: ColorExt.random,
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: child,
          ),
        ),
      ],
    );
  }

  /// 展示菜单取消项
  ///
  /// onTap 点击回调
  /// child 自定义内容
  static Widget buildActionCancel({
    VoidCallback? onTap,
    Widget? child,
  }) {
    return buildActionCell(
      onTap: () {
        if (onTap != null) {
          onTap.call();
        } else {
          Get.back();
        }
      },
      child: child ??
          const NText(
            '取消',
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
  static void showInput({
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

    showCustom(
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 8,
            ),
            Row(
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
            const SizedBox(
              height: 13,
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: onCancel ?? () => Get.back(),
                      child: Container(
                        decoration: BoxDecoration(
                          color: primary.withOpacity(0.08),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                        height: 44,
                        alignment: Alignment.center,
                        child: Text(
                          '取消',
                          style: TextStyle(
                            color: primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 11,
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: onConfirm,
                      child: Container(
                        decoration: BoxDecoration(
                          color: primary,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8),
                          ),
                          gradient: LinearGradient(
                            colors: [primary, primary],
                          ),
                          boxShadow: const [
                            BoxShadow(
                              offset: Offset(0, 5),
                              blurRadius: 10,
                              color: Color(0x52007DBF),
                            )
                          ],
                        ),
                        height: 44,
                        alignment: Alignment.center,
                        child: const Text(
                          '提交',
                          style: TextStyle(
                            color: white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            footer ?? const SizedBox(),
            SizedBox(
              height: max(
                  context == null ? 0 : MediaQuery.of(context).padding.bottom,
                  12),
            ),
            // const SizedBox(
            //   height: 12,
            // ),
          ],
        ),
      ),
    );
  }
}
