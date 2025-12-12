//
//  FootballHighlightsModel.dart
//
//  Created by JsonToModel on 2025-12-04 16:33.
//

import 'package:flutter_templet_project/extension/extension_local.dart';

/// 足球集锦详情模型
class NewsHighlightsDetailModel {
  NewsHighlightsDetailModel({
    this.id,
    this.duration,
    this.title,
    this.nmMatchId,
    this.logo,
    this.url,
  });

  String? id;

  int? duration;

  String? title;

  int? nmMatchId;

  String? logo;

  String? url;

  /// 是视频
  bool get isVideo => AppVideoPlayerService.isVideo(url);

  String? get videoTime {
    if (duration == null) {
      return null;
    }
    final result = Duration(seconds: duration ?? 0).toStringFormat(format: DurationFormatEnum.MMSS);
    return result;
  }

  NewsHighlightsDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    duration = json['duration'];
    title = json['title'];
    nmMatchId = json['nmMatchId'];
    logo = json['logo'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['duration'] = duration;
    map['title'] = title;
    map['nmMatchId'] = nmMatchId;
    map['logo'] = logo;
    map['url'] = url;
    return map;
  }
}
