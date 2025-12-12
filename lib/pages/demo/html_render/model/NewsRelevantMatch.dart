import 'package:flutter_templet_project/pages/demo/html_render/model/NewsMatchTeam.dart';

class NewsRelevantMatch {
  NewsRelevantMatch({
    this.awayTeam,
    this.competitionId,
    this.homeTeam,
    this.id,
    this.sportId,
  });

  NewsMatchTeam? awayTeam;
  int? competitionId;
  NewsMatchTeam? homeTeam;
  int? id;
  int? sportId;

  /// 相关比赛
  void jumpRelevantMatchDetail() {}

  NewsRelevantMatch.fromJson(Map<String, dynamic> json) {
    awayTeam = json['awayTeam'] != null ? NewsMatchTeam.fromJson(json['awayTeam']) : null;
    competitionId = json['competitionId'];
    homeTeam = json['homeTeam'] != null ? NewsMatchTeam.fromJson(json['homeTeam']) : null;
    id = json['id'];
    sportId = json['sportId'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['awayTeam'] = awayTeam?.toJson();
    data['competitionId'] = competitionId;
    data['homeTeam'] = homeTeam?.toJson();
    data['id'] = id;
    data['sportId'] = sportId;
    return data;
  }
}
