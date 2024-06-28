//
//  AePatientCard.dart
//  yl_ylgcp_app
//
//  Created by shang on 2024/6/18 23:23.
//  Copyright © 2024/6/18 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_network_image.dart';
import 'package:flutter_templet_project/basicWidget/n_pair.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/util/color_util.dart';

/// (不良)患者信息卡片
class AePatientCard extends StatelessWidget {
  const AePatientCard({
    super.key,
    required this.title,
    required this.avatar,
    required this.remark,
    required this.section,
    required this.status,
  });

  /// 标题
  final String title;

  /// 头像
  final String avatar;

  /// 备注
  final String remark;

  /// 分组
  final String section;

  /// 状态
  final String status;

  @override
  Widget build(BuildContext context) {
    final isEmpty = [
          title,
          avatar,
          remark,
          section,
          status,
        ].where((e) => e?.isNotEmpty == true).isNotEmpty !=
        true;
    if (isEmpty) {
      return const SizedBox();
    }

    final hasOne =
        [section, status].where((e) => e?.isNotEmpty == true).isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Color(0xFFFFFFFF), width: 1),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        gradient: const LinearGradient(
          colors: [
            Color(0xFFF9F9F9),
            Color(0xFFFFFFFF),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: NPair(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    direction: Axis.vertical,
                    betweenGap: 2,
                    icon: NText(
                      title,
                      color: fontColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 9),
                      child: NText(
                        remark,
                        color: fontColorB3B3B3,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: const BorderRadius.all(Radius.circular(0)),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xff5A5A5A).withOpacity(0.08),
                        blurRadius: 12,
                        offset: Offset(6, 12),
                      )
                    ],
                  ),
                  child: NNetworkImage(
                    url: avatar,
                    width: 48,
                    height: 48,
                    radius: 4,
                  ),
                ),
              ],
            ),
          ),
          if (hasOne)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                buildTag(text: status, textColor: Color(0xffFF8F3E)),
                buildTag(text: section, textColor: Color(0xff01A267)),
              ],
            ),
        ],
      ),
    );
  }

  Widget buildTag({
    required String text,
    required Color textColor,
  }) {
    if (text.isEmpty) {
      return const SizedBox();
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: textColor.withOpacity(0.1),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: NText(
        text,
        color: textColor,
        fontSize: 14,
      ),
    );
  }
}
