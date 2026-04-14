import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/model/match_member_score_model.dart';
import 'package:flutter_templet_project/pages/demo/RatingsStar/player_ratings_star.dart';
import 'package:get/get.dart';

class RatingsStarPage extends StatefulWidget {
  const RatingsStarPage({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<RatingsStarPage> createState() => _RatingsStarPageState();
}

class _RatingsStarPageState extends State<RatingsStarPage> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final scrollController = ScrollController();

  int? myScore;

  late PlayerScoreItemModel item = PlayerScoreItemModel(
    myScore: myScore,
    scoreTimes: ScoreTimesModel(
      s1: 1,
      s2: 1,
      s3: 1,
      s4: 1,
      s5: 1,
    ),
  );

  @override
  void didUpdateWidget(covariant RatingsStarPage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hideApp
          ? null
          : AppBar(
              title: Text("$widget"),
            ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    ValueChanged<PlayerScoreItemModel>? onStarChanged;

    /// 1-5星个数统计
    final Map<int, int> starMap = item.scoreTimes!.ratingsMap;

    return Scrollbar(
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              child: PlayerRatingsStar(
                myScore: item.myScore ?? 0,
                starMap: starMap,
                onRequestRatings: (_, v) => requestRatingsForModel(
                  model: item,
                  score: v.toInt(),
                ),
                onStarChanged: onStarChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }

  initData() {
    item = PlayerScoreItemModel(
      myScore: 0,
      scoreTimes: ScoreTimesModel(
        s1: 1,
        s2: 1,
        s3: 1,
        s4: 1,
        s5: 1,
      ),
    );
  }

  /// 点星评分
  Future<PlayerScoreItemModel> requestRatingsForModel({
    required PlayerScoreItemModel model,
    required int score,
  }) async {
    // final api = ScorePlayerApi(
    //   matchId: widget.matchId,
    //   playerId: model.id,
    //   score: score,
    //   sportId: widget.sportId,
    //   type: model.type,
    // );
    // // if (kDebugMode) {
    // //   if (widget.sportId == 1) {
    // //     api.matchId = 4461002;
    // //   } else {
    // //     api.matchId = 3864368;
    // //   }
    // // }
    // final map = await api.fetch();
    // if (map['code'] != 0) {
    //   ToastHelper.showErrorToast(map['msg']);
    //   return model;
    // }
    // final dataMap = map["data"] as Map<String, dynamic>? ?? <String, dynamic>{};
    // model.scoreTimes = ScoreTimesModel.fromJson(dataMap);
    // model.myScore = score.toInt();
    //
    // widget.onRequestRatingsSuccess?.call();

    initData();
    item.myScore = score.toInt();
    switch (score) {
      case 1:
        {
          item.scoreTimes?.s1 = (item.scoreTimes?.s1 ?? 0) + 1;
        }
        break;
      case 2:
        {
          item.scoreTimes?.s2 = (item.scoreTimes?.s2 ?? 0) + 1;
        }
        break;
      case 3:
        {
          item.scoreTimes?.s3 = (item.scoreTimes?.s3 ?? 0) + 1;
        }
        break;
      case 4:
        {
          item.scoreTimes?.s4 = (item.scoreTimes?.s4 ?? 0) + 1;
        }
        break;
      case 5:
        {
          item.scoreTimes?.s5 = (item.scoreTimes?.s5 ?? 0) + 1;
        }
        break;
      default:
        break;
    }
    setState(() {});
    return model;
  }
}
