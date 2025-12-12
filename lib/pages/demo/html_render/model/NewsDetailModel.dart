import 'package:flutter_templet_project/pages/demo/html_render/model/NewsRelevantMatch.dart';
import 'package:flutter_templet_project/pages/demo/html_render/model/NewsSportItemModel.dart';

class NewsListDataModel {
  NewsListDataModel({
    this.total,
    this.items,
  });

  int? total;

  List<NewsDetailModel>? items;

  NewsListDataModel.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    final values = json['data'] ?? json['items'] ?? [];
    if (values != null) {
      final array = List<Map<String, dynamic>>.from(values);
      items = array.map((e) => NewsDetailModel.fromJson(e)).toList();
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['total'] = total;
    map['items'] = items?.map((v) => v.toJson()).toList();
    return map;
  }
}

/// 资讯详情
class NewsDetailModel {
  NewsDetailModel({
    this.id,
    this.sportId,
    this.top,
    this.title,
    this.thumb,
    this.thumbType,
    this.type,
    this.visitTimes,
    this.createTime,
    this.context,
    this.relevantArticles = const [],
    this.sportItems = const [],
    this.relevantMatch,
    this.isVideo,
    this.videoTime,
  });

  int? id;

  /// 运动种类
  int? sportId;

  int? top;

  String? title;

  String? thumb;

  /// 缩略图样式1.左文右图 2.上文下图 3.三图并列 4.无图模式 5.社媒一图 6.社媒多图
  int? thumbType;

  /// 资讯分类. 0:赛中资讯;1:战报;2:赛中动图
  int? type;

  /// 访问次数
  int? visitTimes;

  String? createTime;

  /// 资讯具体内容
  String? context;

  /// 相关资讯
  List<NewsDetailModel>? relevantArticles;

  /// 相关数据信息(资讯详情中,相关比赛,赛事,球队,球员的数据结构)
  List<NewsSportItemModel>? sportItems;

  /// 相关比赛信息(资讯详情中,相关比赛,赛事,球队,球员的数据结构_1)
  List<NewsRelevantMatch>? relevantMatch;

  bool? isVideo;

  String? videoTime;

  /// 标签
  String get tag {
    var tag = "";
    // if (top == 1) {
    //   tag = "置顶";
    // } else if (typeEnum == NewsTypeEnum.last) {
    //   tag = "战报";
    // }
    return tag;
  }

  NewsDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sportId = json['sportId'];
    top = json['top'];
    title = json['title'];
    thumb = json['thumb'];
    thumbType = json['thumbType'];
    type = json['type'];
    visitTimes = json['visitTimes'];
    createTime = json['createTime'];
    context = json['context'];
    if (json['relevantArticles'] != null) {
      final array = List<Map<String, dynamic>>.from(json['relevantArticles'] ?? []);
      relevantArticles = array.map((e) => NewsDetailModel.fromJson(e)).toList();
    }
    if (json['sportItems'] != null) {
      final array = List<Map<String, dynamic>>.from(json['sportItems'] ?? []);
      sportItems = array.map((e) => NewsSportItemModel.fromJson(e)).toList();
    }
    if (json['relevantMatch'] != null) {
      final array = List<Map<String, dynamic>>.from(json['relevantMatch'] ?? []);
      relevantMatch = array.map((e) => NewsRelevantMatch.fromJson(e)).toList();
    }
    isVideo = json['isVideo'];
    videoTime = json['videoTime'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['sportId'] = sportId;
    map['top'] = top;
    map['title'] = title;
    map['thumb'] = thumb;
    map['thumbType'] = thumbType;
    map['type'] = type;
    map['visitTimes'] = visitTimes;
    map['createTime'] = createTime;
    map['context'] = context;
    map['relevantArticles'] = relevantArticles?.map((v) => v.toJson()).toList();
    map['sportItems'] = sportItems?.map((v) => v.toJson()).toList();
    map['relevantMatch'] = relevantMatch?.map((v) => v.toJson()).toList();
    map['isVideo'] = isVideo;
    map['videoTime'] = videoTime;
    return map;
  }
}
