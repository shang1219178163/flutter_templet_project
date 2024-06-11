//
//  NOriginSheet.dart
//  flutter_templet_project
//
//  Created by shang on 2024/1/6 11:54.
//  Copyright © 2024/1/6 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_textfield.dart';
import 'package:flutter_templet_project/cache/cache_service.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';
import 'package:flutter_templet_project/network/RequestConfig.dart';
import 'package:flutter_templet_project/util/color_util.dart';

import 'package:flutter_templet_project/vendor/toast_util.dart';

/// 域名选择器
class NOriginSheet extends StatefulWidget {
  NOriginSheet({
    super.key,
    this.onChanged,
  });

  /// 改变回调
  final void Function(APPEnvironment env, String origin)? onChanged;

  @override
  State<NOriginSheet> createState() => _NOriginSheetState();
}

class _NOriginSheetState extends State<NOriginSheet> {
  final textController = TextEditingController();

  APPEnvironment get currentEnv {
    final env = CacheService().env;
    final result = env ?? RequestConfig.current;
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return buildOriginSheet();
  }

  /// 域名选择
  Widget buildOriginSheet() {
    if (currentEnv == APPEnvironment.prod && kReleaseMode) {
      return const SizedBox();
    }

    const list = APPEnvironment.values;

    // final currentWidget = Column(
    //   children: [
    //     // Text(RequestChannel.baseUrl,),
    //     Text("当前域名: ${currentEnv.name}",),
    //     Text("当前域名: ${currentEnv.origin}",),
    //   ],
    // );

    final currentWidget = Column(
      children: "${currentEnv}".split(",").map((e) {
        return Text(
          e,
        );
      }).toList(),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: () {
              showAlertSheet(
                message: currentWidget,
                actions: list.map((e) {
                  final origin = e.toString().split(",").last;

                  return ListTile(
                    dense: true,
                    onTap: () {
                      Navigator.of(context).pop();

                      onUpdate(env: e, origin: origin);
                    },
                    title: Text(e.name.toString()),
                    subtitle: Text(origin),
                    trailing: Icon(
                      Icons.check,
                      color: currentEnv == e ? Colors.blue : Colors.transparent,
                    ),
                  );
                }).toList(),
              );
            },
            child: currentWidget,
          ),
          const SizedBox(
            width: 4,
          ),
          Opacity(
            opacity: currentEnv == APPEnvironment.dev ? 1 : 0,
            child: InkWell(
                onTap: () {
                  // YLog.d("edit");

                  showAlertTextField(onChanged: (String value) {
                    ddlog("showAlertTextField $value");
                    onUpdate(env: APPEnvironment.dev, origin: value);
                  });
                },
                child: Icon(
                  Icons.edit,
                  color: Colors.red,
                )),
          ),
        ],
      ),
    );
  }

  void showAlertSheet({
    Widget title = const Text("请选择"),
    Widget? message,
    required List<Widget> actions,
  }) {
    CupertinoActionSheet(
      title: title,
      message: message,
      actions: actions,
      cancelButton: CupertinoActionSheetAction(
        isDestructiveAction: true,
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text('取消'),
      ),
    ).toShowCupertinoModalPopup(context: context);
  }

  void showAlertTextField({
    Widget? title = const Text("请选择"),
    Widget? message,
    required ValueChanged<String> onChanged,
  }) {
    textController.text = RequestConfig.baseUrl;

    CupertinoAlertDialog(
      title: title ??
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Text(
              "请输入",
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      content: message ??
          NTextField(
            controller: textController,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: fontColor,
            ),
            isCollapsed: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            onChanged: (String value) {
              // YLog.d("onChanged $value");
            },
            onSubmitted: (String value) {
              // YLog.d("onSubmitted $value");
            },
          ),
      actions: ["取消", "确定"]
          .map((e) => TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () {
                  if (e == "确定") {
                    final val = textController.text.trim();
                    if (!val.startsWith("http")) {
                      ToastUtil.show("必须以 http 开头");
                      return;
                    }
                    onChanged(val);
                  }
                  Navigator.pop(context);
                },
                child: Text(e),
              ))
          .toList(),
    ).toShowCupertinoModalPopup(context: context);
  }

  onUpdate({
    required APPEnvironment env,
    required String origin,
  }) {
    RequestConfig.current = env;
    CacheService().env = env;
    if (env == APPEnvironment.dev) {
      CacheService().devOrigin = origin;
    }
    setState(() {});

    widget.onChanged?.call(env, origin);
  }
}
