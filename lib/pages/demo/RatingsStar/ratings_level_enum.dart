//
//  NStarLevelPrecent.dart
//  projects
//
//  Created by shang on 2026/1/15 15:31.
//  Copyright © 2026/1/15 shang. All rights reserved.
//

import 'package:flutter/material.dart';

/// 评分等级
enum RatingsLevelEnum {
  eightToTen(
    min: 8,
    max: 10.1, //兼容整数10
    color: Color(0xFFE91025),
    desc: "8-10分",
  ),
  sixToEight(
    min: 6,
    max: 8,
    color: Color(0xFFffb700),
    desc: "6-8分",
  ),
  other(
    min: 0,
    max: 6,
    color: Color(0xFF7C7C85),
    desc: "6分以下",
  ),
  ;

  const RatingsLevelEnum({
    required this.min,
    required this.max,
    required this.color,
    required this.desc,
  });

  final double min;
  final double max;
  final Color color;

  final String desc;

  @override
  String toString() {
    return {
      "min": min,
      "max": max,
      "color": color.toString(),
      "desc": desc,
    }.toString();
  }
}

class RatingsInfoModel {
  const RatingsInfoModel({
    required this.averageScore,
    required this.totalCount,
    required this.starCounts,
    required this.starPercents,
    required this.ratingEnum,
  });

  final double averageScore; // 平均分（1 位小数）
  final int totalCount; // 总人数
  final Map<int, int> starCounts; // 星级 -> 人数
  final Map<int, double> starPercents; // 星级 -> 占比 %
  final RatingsLevelEnum ratingEnum; // 投票枚举

  static RatingsInfoModel calculateRating({required Map<int, int> starMap}) {
    var totalCount = 0;
    var totalScore = 0;

    // 统一补齐 1～5 星，保证结构稳定
    final normalized = <int, int>{
      for (int i = 1; i <= 5; i++) i: starMap[i] ?? 0,
    };

    for (final entry in normalized.entries) {
      final star = entry.key;
      final count = entry.value;

      totalCount += count;
      totalScore += 2 * star * count;
    }

    final averageScore = (totalCount == 0 ? 0 : totalScore / totalCount).clamp(0, 10);
    final averageScoreNew = double.parse(averageScore.toStringAsFixed(1)); // 四舍五入
    // DLog.d(["averageScore", starMap, "$totalCount/$totalScore", averageScore, averageScoreNew]);

    final starPercents = <int, double>{
      for (final e in normalized.entries)
        e.key: totalCount == 0
            ? 0
            : double.tryParse(
                  (e.value / totalCount).toStringAsFixed(4),
                ) ??
                0,
    };

    final ratingEnum =
        RatingsLevelEnum.values.where((e) => averageScore >= e.min && averageScore < e.max).firstOrNull ??
            RatingsLevelEnum.other;

    return RatingsInfoModel(
      averageScore: averageScoreNew,
      totalCount: totalCount,
      starCounts: normalized,
      starPercents: starPercents,
      ratingEnum: ratingEnum,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['averageScore'] = averageScore;
    map['totalCount'] = totalCount;
    map['starCounts'] = starCounts;
    map['starPercents'] = starPercents;
    return map;
  }
}
