//
//  MemberScoreModel.dart
//
//  Created by JsonToModel on 2026-01-19 15:53.
//

import "package:flutter_templet_project/enum/ratings_level_enum.dart";

/// 比赛成员评分
class MatchMemberScoreDataModel {
  MatchMemberScoreDataModel({
    this.playerScoreItem = const [],
    this.overView = const [],
    this.home,
    this.away,
  });

  List<PlayerScoreItemModel>? playerScoreItem;

  List<PlayerScoreItemModel>? overView;

  Team? home;

  Team? away;

  MatchMemberScoreDataModel.fromJson(Map<String, dynamic> json) {
    if (json['playerScoreItem'] != null) {
      final array = List<Map<String, dynamic>>.from(json['playerScoreItem'] ?? []);
      playerScoreItem = array.map((e) => PlayerScoreItemModel.fromJson(e)).toList();
    }
    if (json['overView'] != null) {
      final array = List<Map<String, dynamic>>.from(json['overView'] ?? []);
      overView = array.map((e) => PlayerScoreItemModel.fromJson(e)).toList();
    }
    home = json['home'] != null ? Team.fromJson(json['home'] as Map<String, dynamic>) : null;
    away = json['away'] != null ? Team.fromJson(json['away'] as Map<String, dynamic>) : null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['playerScoreItem'] = playerScoreItem?.map((v) => v.toJson()).toList();
    map['overView'] = overView?.map((v) => v.toJson()).toList();
    if (home != null) {
      map['home'] = home!.toJson();
    }
    if (away != null) {
      map['away'] = away!.toJson();
    }
    return map;
  }
}

class PlayerScoreItemModel {
  PlayerScoreItemModel({
    this.sportId,
    this.id,
    this.type,
    this.teamId,
    this.teamLogo,
    this.shortName,
    this.logo,
    this.totalTime,
    this.shirtNumber,
    this.attendType,
    this.attendTime,
    this.leaveTime,
    this.red,
    this.yellow,
    this.score,
    this.scorePenalty,
    this.assists,
    this.myScore,
    this.mediaRating,
    this.plateRating,
    this.scoreTimes,
    this.showType,
    this.position,
    this.countryLogo,
    this.countryName,
    this.age,
    this.hot,
    // this.ratingsModel,
  });

  /// 1 足球,2篮球
  int? sportId;

  ///
  int? id;

  /// 0:球员;1:教练;3:裁判;4:视频裁判;其余自定义
  int? type;

  ///
  int? teamId;

  String? teamLogo;

  /// 名称简称
  String? shortName;

  /// 用户头像
  String? logo;

  /// 总评分次数
  int? totalTime;

  /// 球衣号
  int? shirtNumber;

  /// 参与类型(0:未上场;1:首发全场;2:首发;3:替补上场;)
  int? attendType;

  /// 参与时间(上场时间或者离场时间). 单位:分
  int? attendTime;

  int? leaveTime;

  /// 红牌数
  int? red;

  /// 黄牌数
  int? yellow;

  /// 总进球
  int? score;

  /// 点球过程中的得分
  int? scorePenalty;

  /// 助攻
  int? assists;

  /// 我对该球员的评分(几颗星)
  int? myScore;

  /// 媒体评分
  String? mediaRating;

  /// 平台评分
  String? plateRating;

  /// 评分次数的比值
  ScoreTimesModel? scoreTimes;

  /// 0:媒体评分;1:平台(看比赛)评分
  int? showType;

  /// 足球:擅长位置，F-前锋、M-中场、D-后卫、G-守门员、其他为未知
  /// 篮球: 位置(C-中锋, SF-小前锋, PF-大前锋, SG-得分后卫, PG-组织后卫, F-前锋, G-后卫，其它都为未知)
  String? position;

  /// 国旗
  String? countryLogo;

  /// 国家名称
  String? countryName;

  ///
  int? age;

  /// 是否热门球员
  bool? hot;

  /// 篮板数
  int? rebounds;

  /// 是 Var
  bool get isVar => shortName == "VAR";

  /// 是媒体评分
  bool get showTypeMedia => showType == 0;

  /// 0:媒体评分;1:平台(看比赛)评分
  String? get showTypeDesc => {0: "媒体评分", 1: "看比赛评分"}[showType] ?? "";

  PlayerScoreItemModel.fromJson(Map<String, dynamic> json) {
    sportId = json['sportId'];
    id = json['id'];
    type = json['type'];
    teamId = json['teamId'];
    teamLogo = json['teamLogo'];
    shortName = json['shortName'];
    logo = json['logo'];
    totalTime = json['totalTime'];
    shirtNumber = json['shirtNumber'];
    attendType = json['attendType'];
    attendTime = json['attendTime'];
    leaveTime = json['leaveTime'];
    red = json['red'] ?? 0;
    yellow = json['yellow'] ?? 0;
    score = json['score'] ?? 0;
    scorePenalty = json['scorePenalty'] ?? 0;
    assists = json['assists'] ?? 0;
    rebounds = json['rebounds'] ?? 0;
    myScore = json['myScore'] ?? 0;
    mediaRating = json['mediaRating'];
    plateRating = json['plateRating'];
    scoreTimes =
        json['scoreTimes'] != null ? ScoreTimesModel.fromJson(json['scoreTimes'] as Map<String, dynamic>) : null;
    showType = json['showType'];
    position = json['position'];
    countryLogo = json['countryLogo'];
    countryName = json['countryName'];
    age = json['age'];
    hot = json['hot'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['sportId'] = sportId;
    map['id'] = id;
    map['type'] = type;
    map['teamId'] = teamId;
    map['teamLogo'] = teamLogo;
    map['shortName'] = shortName;
    map['logo'] = logo;
    map['totalTime'] = totalTime;
    map['shirtNumber'] = shirtNumber;
    map['attendType'] = attendType;
    map['attendTime'] = attendTime;
    map['leaveTime'] = leaveTime;
    map['red'] = red;
    map['yellow'] = yellow;
    map['score'] = score;
    map['scorePenalty'] = scorePenalty;
    map['assists'] = assists;
    map['myScore'] = myScore;
    map['mediaRating'] = mediaRating;
    map['plateRating'] = plateRating;
    if (scoreTimes != null) {
      map['scoreTimes'] = scoreTimes!.toJson();
    }
    map['hot'] = hot;
    return map;
  }
}

class Team {
  Team({
    required this.name,
    required this.logo,
    required this.id,
    this.position,
  });

  String name;
  String logo;
  int id;
  String? position;

  factory Team.fromJson(Map<dynamic, dynamic> json) => Team(
        name: json["name"],
        logo: json["logo"],
        id: json["id"],
        position: json["position"],
      );

  Map<dynamic, dynamic> toJson() => {
        "name": name,
        "logo": logo,
        "id": id,
        "position": position,
      };
}

/// 1-5颗星评分及对应的数量
class ScoreTimesModel {
  ScoreTimesModel({
    this.s1,
    this.s2,
    this.s3,
    this.s4,
    this.s5,
  });

  int? s1;

  int? s2;

  int? s3;

  int? s4;

  int? s5;

  /// 等级
  Map<int, int> get ratingsMap {
    final Map<int, int> result = toJson().map(
      (key, value) => MapEntry(int.parse(key), value),
    );
    return result;
  }

  /// 粉丝点评信息模型
  RatingsInfoModel get ratingsModel => RatingsInfoModel.calculateRating(starMap: ratingsMap);

  ScoreTimesModel.fromJson(Map<String, dynamic> json) {
    s1 = json['1'];
    s2 = json['2'];
    s3 = json['3'];
    s4 = json['4'];
    s5 = json['5'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['1'] = s1;
    map['2'] = s2;
    map['3'] = s3;
    map['4'] = s4;
    map['5'] = s5;
    return map;
  }
}
