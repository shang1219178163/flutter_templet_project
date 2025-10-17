//
//  AeQuestionnaireCard.dart
//  yl_ylgcp_app
//
//  Created by shang on 2024/6/26 13:05.
//  Copyright © 2024/6/26 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_pair.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/extension/type_util.dart';
import 'package:flutter_templet_project/util/app_color.dart';

/// 不良事件问卷信息展示
class AeQuestionnaireCard<T> extends StatelessWidget {
  const AeQuestionnaireCard({
    super.key,
    required this.items,
    this.footer,
    this.onTap,
  });

  final List<ChooseItemRecord<T>> items;
  final Widget? footer;

  final ValueChanged<ChooseItemRecord<T>>? onTap;

  @override
  Widget build(BuildContext context) {
    if (items.isNotEmpty != true) {
      return const SizedBox();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...items.map((e) => buildItem(context: context, e: e)).toList(),
        footer ??
            Container(
              margin: EdgeInsets.only(top: 10),
              padding: const EdgeInsets.symmetric(vertical: 4),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColor.cancelColor.withOpacity(0.1),
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              child: NText(
                "注：AE&SAE表单仅支持PC端添加与填写。",
                fontSize: 14,
                color: AppColor.cancelColor,
                maxLines: 1,
              ),
            ),
      ],
    );
  }

  Widget buildItem({required BuildContext context, required ChooseItemRecord<T> e}) {
    return InkWell(
      onTap: () {
        onTap?.call(e);
      },
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 36),
        // margin: const EdgeInsets.only(top: 5),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: AppColor.white,
          border: Border.all(color: const Color(0xFFE6E6E6), width: 0.5),
          boxShadow: const [
            BoxShadow(
              color: Color(0x08000000),
              blurRadius: 16,
              offset: Offset(0, 5),
            )
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: NText(
                e.title,
                fontSize: 14,
                color: AppColor.fontColor,
                maxLines: 1,
              ),
            ),
            const SizedBox(width: 8),
            NPair(
              isReverse: true,
              icon: Image(
                image: "icon_arrow_right.png".toAssetImage(),
                width: 16,
                height: 16,
              ),
              child: NText(
                "查看详情",
                color: context.primaryColor,
                fontSize: 14,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
