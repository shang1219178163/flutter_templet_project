import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_avatar_badge.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';

import 'package:flutter_templet_project/network/dio_upload_service.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

/// 会话列表 cell
class IMConversationCell extends StatelessWidget {
  const IMConversationCell({
    Key? key,
    required this.title,
    required this.imgUrl,
    this.decorationImage,
    this.groupId = "",
    this.subtitle = "",
    this.badgeValue = 0,
    this.time = "",
    this.spacing = 16,
    this.runSpacing = 12,
    this.imgSize = 48,
    this.imgGap = 10,
    this.bgColor,
    this.decoration,
    this.highlightContent = '',
    // this.groupAtInfoList,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final String time;
  final double spacing;
  final double runSpacing;
  final String imgUrl;
  final DecorationImage? decorationImage;
  final double imgSize;
  final double imgGap;
  final int badgeValue;

  final String? groupId;
  final Color? bgColor;
  final Decoration? decoration;
  final String? highlightContent; //标题需要高亮的内容
  // final List<V2TimGroupAtInfo?>? groupAtInfoList;

  @override
  Widget build(BuildContext context) {
    return buildIMCell(
      imgUrl: imgUrl,
      groupId: groupId ?? "",
      title: title,
      subtitle: subtitle,
      time: time,
      spacing: spacing,
      runSpacing: runSpacing,
      imgSize: imgSize,
      imgGap: imgGap,
      badgeValue: badgeValue,
      highlightContent: highlightContent!,
    );
  }

  buildIMCell({
    required String imgUrl,
    required String title,
    String groupId = "",
    String subtitle = "",
    String time = "",
    double spacing = 16,
    double runSpacing = 12,
    int badgeValue = 0,
    double imgSize = 48,
    double imgGap = 16,
    String highlightContent = '', //标题需要高亮的内容
  }) {
    // badgeValue = randomInt(199);//add test

    final now = DateTime.now();
    final nowStr = DateTimeExt.stringFromDate(date: now);
    // final bool isAt = groupAtInfoList != null && groupAtInfoList!.isNotEmpty;
    final currentYear = "$now".substring(0, 4);
    final isTeam = groupId != "" && groupId.contains("CONSULTATION");

    if (time.length > 11 && time.startsWith(currentYear)) {
      if (nowStr?.substring(0, 11) == time.substring(0, 11)) {
        time = time.substring(11, 16);
        // time = time.substring(11, 19);//add test
      } else {
        time = time.substring(5, 10);
      }
    } else {
      if (time.isNotEmpty) {
        time = time.substring(0, 11);
      }
    }

    final hideBadge = badgeValue == 0;

    var badgeValueStr = hideBadge ? "" : "$badgeValue";
    if (badgeValue > 99) {
      badgeValueStr = "···";
    }

    // subtitle = subtitle.replaceAll('', '\u200B');

    //根据关键字拆分text
    List<String> keywordSegmentationString(String text, String keyword) {
      var textList = <String>[];
      List texts = text.split(keyword);
      texts.asMap().forEach((key, value) {
        if (key != 0 && key != texts.length) {
          textList.add(keyword);
        }
        textList.add(value);
      });

      return textList;
    }

    final content = Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            NAvatarBadge(
              url: url,
              decorationImage: decorationImage,
              badgeStr: badgeValueStr == "0" ? "" : badgeValueStr,
              badgeSize: 16,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 12, right: spacing),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: highlightContent.isNotEmpty
                              ? RichText(
                                  maxLines: 1,
                                  textDirection: TextDirection.ltr,
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                    text: '',
                                    style: const TextStyle(
                                      color: AppColor.fontColor,
                                      fontSize: 17,
                                    ),
                                    children: [
                                      ...keywordSegmentationString(title, highlightContent).map((e) {
                                        return TextSpan(
                                            text: e,
                                            style: TextStyle(
                                              color: e == highlightContent ? AppColor.primary : AppColor.fontColor,
                                              fontSize: 17,
                                            ));
                                      }).toList()
                                    ],
                                  ),
                                )
                              : NText(
                                  title,
                                  color: AppColor.fontColor,
                                  fontSize: 17,
                                  fontWeight: FontWeight.normal,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(left: 8),
                          child: NText(
                            time,
                            color: const Color(0xFFCCCCCC),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 0, bottom: 2),
                      child: Row(
                        children: [
                          // if (isAt)
                          //   const YlText(
                          //     data: '[有人@我] ',
                          //     color: Color(0xFFFA5151),
                          //     fontSize: 14,
                          //   ),
                          Expanded(
                            child: NText(
                              subtitle,
                              textAlign: TextAlign.left,
                              maxLines: 1,
                              fontWeight: FontWeight.w400,
                              color: AppColor.fontColor,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: runSpacing),
        Divider(
          height: 1,
          indent: (imgGap + imgSize) + 1,
          // indent:12,
          color: AppColor.lineColor,
        ),
      ],
    );

    return Container(
      // height: 72.w,
      padding: EdgeInsets.only(left: spacing, top: runSpacing),
      decoration: decoration ??
          BoxDecoration(
            color: bgColor ?? Colors.white,
          ),
      child: content,
    );
  }
}
