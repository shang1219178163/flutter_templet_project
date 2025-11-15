import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_cross_fade_mask.dart';

import 'package:flutter_templet_project/util/AppRes.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

class IntrinsicHeightDemo extends StatefulWidget {
  const IntrinsicHeightDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _IntrinsicHeightDemoState createState() => _IntrinsicHeightDemoState();
}

class _IntrinsicHeightDemoState extends State<IntrinsicHeightDemo> {
  bool flag = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: [
          TextButton(
              onPressed: () {
                flag = !flag;
                setState(() {});
              },
              child: Icon(
                Icons.change_circle_outlined,
                color: Colors.white,
              )),
        ],
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          buildItemHorizal(),
          buildRow(),
          PredictionItem(),
        ],
      ),
    );
  }

  Widget buildItemHorizal() {
    return IntrinsicHeight(
      child: Row(
        children: [
          Container(
            width: 50,
            color: Colors.red,
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            width: 28,
            height: 50,
            color: Colors.red,
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            width: 50,
            height: 150,
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget buildRow() {
    return IntrinsicHeight(
      child: Container(
        child: Row(children: [
          Container(
            width: 100,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue),
              image: DecorationImage(
                image: NetworkImage(AppRes.image.urls[0]),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Spacer(),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue),
            ),
            child: Column(
              children: [
                Text(
                  'title',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  'subtitle',
                  style: TextStyle(fontWeight: FontWeight.w400),
                ),
                Text(
                  'description',
                  style: TextStyle(fontWeight: FontWeight.w400),
                ),
                Text(
                  'remark',
                  style: TextStyle(fontWeight: FontWeight.w400),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}

class PredictionItem extends StatelessWidget {
  const PredictionItem({
    super.key,
    this.isExpand = false,
    this.hasIndicator = true,
    this.onTapSchemeMatch,
  });

  final bool isExpand;
  final bool hasIndicator;

  final ValueChanged<SchemeMatchEntity>? onTapSchemeMatch;

  @override
  Widget build(BuildContext context) {
    var schemeMatchs = List.generate(9, (i) {
      final json = {
        "matchId": 4437589,
        "competitionShortName": "球会友谊",
        "matchTimeStr": "2025-09-29 12:00",
        "matchTime": 1759118400,
        "homeTeamName": "秋田蓝闪电",
        "awayTeamName": "岩手盛冈仙鹤"
      };
      return SchemeMatchEntity.fromJson(json);
    }); //add test

    final predictionTag = '[标签] ';

    final schemeOdds = "12";

    final title = "天行健,君子志强不息";
    final createTimeStr = DateTime.now().toString19();
    final viewCount = 99;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8).copyWith(left: 0),
      decoration: BoxDecoration(
        color: Color(0xff242434),
        // borderRadius: BorderRadius.circular(8),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (hasIndicator)
              Container(
                width: 3,
                // height: double.infinity,
                margin: const EdgeInsets.only(right: 13),
                decoration: BoxDecoration(
                  color: Colors.red,
                  // border: Border.all(color: Colors.blue),
                ),
              ),
            Expanded(
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: predictionTag,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Color(0xffE91025),
                                          ),
                                        ),
                                        TextSpan(
                                          text: title.trimLeft() ?? "-",
                                          style: TextStyle(fontSize: 16, color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      buildMagnification(schemeOdds: schemeOdds),
                    ],
                  ),
                  const SizedBox(height: 4),
                  SchemeMatchWidget(
                    models: schemeMatchs,
                    onTap: onTapSchemeMatch,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '发布时间 ${createTimeStr}',
                        style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.6)),
                      ),
                      const Spacer(),
                      Text(
                        '${viewCount}人感兴趣',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.6),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 倍率
  Widget buildMagnification({required String? schemeOdds, bool isReversed = false}) {
    const labStyle = TextStyle(
      fontSize: 14,
      color: Color(0xffE91025),
      fontWeight: FontWeight.w500,
      height: 1.1,
    );

    const valueStyle = TextStyle(
      fontSize: 14,
      color: Color(0xffE91025),
      fontWeight: FontWeight.bold,
      height: 1.1,
    );

    return Container(
      width: 40,
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        // border: Border.all(color: Colors.blue),
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(4),
      ),
      child: isReversed
          ? FittedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('赔率', style: labStyle),
                  const SizedBox(height: 4),
                  Text('${schemeOdds == '0' ? '--' : schemeOdds}', style: labStyle)
                ],
              ),
            )
          : FittedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${schemeOdds == '0' ? '--' : schemeOdds}', style: labStyle),
                  const SizedBox(height: 4),
                  Text('倍', style: labStyle),
                ],
              ),
            ),
    );
  }
}

/// SchemeMatch 对应的组件
class SchemeMatchItem extends StatelessWidget {
  const SchemeMatchItem({
    super.key,
    this.textWidth,
    required this.value,
    required this.isLast,
  });

  final double? textWidth;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: isLast ? 0 : 4),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        // border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              width: textWidth,
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xffA7A7AE),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 4),
            // decoration: BoxDecoration(
            //   border: Border.all(color: Colors.blue),
            // ),
            child: Icon(
              Icons.arrow_forward_ios,
              size: 10,
              color: Color(0xffA7A7AE),
            ),
          ),
        ],
      ),
    );
  }
}

/// 策划匹配
class SchemeMatchWidget extends StatelessWidget {
  const SchemeMatchWidget({
    super.key,
    this.textWidth,
    this.sportType = 'football',
    required this.models,
    this.onTap,
  });

  final double? textWidth;
  final String? sportType;
  final List<SchemeMatchEntity>? models;
  final ValueChanged<SchemeMatchEntity>? onTap;

  @override
  Widget build(BuildContext context) {
    var schemeMatchDescs = (models ?? []).map((e) {
      var date = DateTime.fromMillisecondsSinceEpoch((e.matchTime ?? 0) * 1000);
      var formatter = DateFormat('MM/dd HH:mm');
      final result = '${e.competitionShortName} ${formatter.format(date)}'
          ' ｜ '
          '${sportType == 'football' ? e.homeTeamName : e.awayTeamName}'
          ' VS '
          '${sportType == 'football' ? e.awayTeamName : e.homeTeamName}';

      // final timeStr = formatTime(timeStr: e.matchTimeStr ?? '');
      // final result = "${e.competitionShortName} $timeStr ｜ ${e.homeTeamName} VS ${e.awayTeamName}";
      return result;
    }).toList();

    // schemeMatchDescs = List.generate(9, (i) => "$i 西甲 08/23 15:30 ｜ 多特蒙德 VS 罗马"); //add test

    return NCrossFadeMask(
      items: schemeMatchDescs,
      expandTitle: "展开所有场次",
      first: (limit) {
        return Column(
          children: schemeMatchDescs.sublist(0, limit).map((v) {
            final i = schemeMatchDescs.indexOf(v);

            return GestureDetector(
              onTap: () {
                onTap?.call((models ?? [])[i]);
              },
              child: SchemeMatchItem(
                textWidth: textWidth,
                value: v,
                isLast: v == schemeMatchDescs.last,
              ),
            );
          }).toList(),
        );
      },
      secondChild: (onToggle) {
        return Column(
          children: schemeMatchDescs.map((v) {
            final i = schemeMatchDescs.indexOf(v);

            return GestureDetector(
              onTap: () {
                onTap?.call((models ?? [])[i]);
              },
              child: SchemeMatchItem(
                textWidth: textWidth,
                value: v,
                isLast: v == schemeMatchDescs.last,
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class SchemeMatchEntity {
  int? matchId;
  String? competitionShortName;
  String? matchTimeStr;
  int? matchTime;
  String? homeTeamName;
  String? awayTeamName;

  SchemeMatchEntity({
    this.matchId,
    this.competitionShortName,
    this.matchTimeStr,
    this.matchTime,
    this.homeTeamName,
    this.awayTeamName,
  });

  SchemeMatchEntity.fromJson(Map<String, dynamic> json) {
    matchId = json['matchId'];
    competitionShortName = json['competitionShortName'];
    matchTimeStr = json['matchTimeStr'];
    matchTime = json['matchTime'];
    homeTeamName = json['homeTeamName'];
    awayTeamName = json['awayTeamName'];
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['matchId'] = matchId;
    data['competitionShortName'] = competitionShortName;
    data['matchTimeStr'] = matchTimeStr;
    data['matchTime'] = matchTime;
    data['homeTeamName'] = homeTeamName;
    data['awayTeamName'] = awayTeamName;
    return data;
  }
}
