import 'package:flutter_templet_project/pages/demo/html_render/model/article_match_team.dart';

class ArticleRelevantMatch {

  ArticleRelevantMatch.fromJson(Map<String, dynamic> json) {
    awayTeam = json['awayTeam'] != null ? ArticleMatchTeam.fromJson(json['awayTeam']) : null;
    competitionId = json['competitionId'];
    homeTeam = json['homeTeam'] != null ? ArticleMatchTeam.fromJson(json['homeTeam']) : null;
    id = json['id'];
    sportId = json['sportId'];
  }
  ArticleRelevantMatch({
    this.awayTeam,
    this.competitionId,
    this.homeTeam,
    this.id,
    this.sportId,
  });

  ArticleMatchTeam? awayTeam;
  int? competitionId;
  ArticleMatchTeam? homeTeam;
  int? id;
  int? sportId;

  /// 相关比赛
  void jumpRelevantMatchDetail() {}

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
