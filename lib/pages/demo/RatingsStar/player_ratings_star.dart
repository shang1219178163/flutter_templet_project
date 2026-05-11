import 'package:flutter/material.dart';
import 'package:flutter_templet_project/generated/assets.dart';
import 'package:flutter_templet_project/model/match_member_score_model.dart';
import 'package:flutter_templet_project/pages/demo/RatingsStar/n_rating_stars.dart';
import 'package:flutter_templet_project/pages/demo/RatingsStar/ratings_level_enum.dart';
import 'package:flutter_templet_project/util/theme/theme_provider.dart';
import 'package:provider/provider.dart';

/// 1-5星百分比显示
class PlayerRatingsStar extends StatefulWidget {
  const PlayerRatingsStar({
    super.key,
    required this.myScore,
    required this.starMap,
    required this.onRequestRatings,
    required this.onStarChanged,
  });

  /// 1-5星个数统计
  final Map<int, int> starMap;

  final int myScore;

  final Future<PlayerScoreItemModel> Function(BuildContext context, double v) onRequestRatings;

  final ValueChanged<PlayerScoreItemModel>? onStarChanged;

  @override
  State<PlayerRatingsStar> createState() => _PlayerRatingsStarState();
}

class _PlayerRatingsStarState extends State<PlayerRatingsStar> {
  late final themeProvider = context.read<ThemeProvider>();

  late var starMap = widget.starMap ?? <int, int>{5: 0, 4: 0, 3: 0, 2: 0, 1: 0};

  late var myScore = widget.myScore;

  late final ratingsStarVN = ValueNotifier(myScore.toDouble());

  initData() {
    starMap = widget.starMap;
    myScore = widget.myScore;
    ratingsStarVN.value = myScore.toDouble();
  }

  @override
  void didUpdateWidget(covariant PlayerRatingsStar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.starMap != widget.starMap || oldWidget.myScore != widget.myScore) {
      initData();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    /// 已打分
    final hadStar = myScore > 0;
    final starTitle = hadStar ? "已评分" : "为TA本场表现打分";

    final ratingsModel = RatingsInfoModel.calculateRating(starMap: starMap);
    final fansCount = ratingsModel.totalCount;

    late var averageScoreEnum = ratingsModel.ratingEnum;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12).copyWith(bottom: 8),
      decoration: BoxDecoration(
        color: themeProvider.color242434OrWhite,
        border: Border.all(color: themeProvider.lineColor, width: 1),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 70,
                  margin: EdgeInsets.only(right: 30),
                  // decoration: BoxDecoration(
                  //   color: Colors.transparent,
                  //   border: Border.all(color: Colors.blue),
                  //   borderRadius: BorderRadius.all(Radius.circular(0)),
                  // ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        child: Text(
                          '看比赛评分',
                          style: TextStyle(
                            color: Color(0x0ffe4455),
                            fontSize: 13,
                            fontFamily: 'PingFang SC',
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                        ),
                      ),
                      Text(
                        '${ratingsModel.averageScore}',
                        style: TextStyle(
                          color: averageScoreEnum.color,
                          fontSize: 30,
                          fontFamily: 'PingFang SC',
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.60,
                          // height: 1.0,
                        ),
                      ),
                      Text(
                        '$fansCount 球迷评分',
                        style: TextStyle(
                          color: themeProvider.subtitleColor,
                          fontSize: 11,
                          fontFamily: 'PingFang SC',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    // decoration: BoxDecoration(
                    //   color: Colors.transparent,
                    //   border: Border.all(color: Colors.blue),
                    //   borderRadius: BorderRadius.all(Radius.circular(0)),
                    // ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(child: buildStar(starLevel: 5, starPercents: ratingsModel.starPercents)),
                        Flexible(child: buildStar(starLevel: 4, starPercents: ratingsModel.starPercents)),
                        Flexible(child: buildStar(starLevel: 3, starPercents: ratingsModel.starPercents)),
                        Flexible(child: buildStar(starLevel: 2, starPercents: ratingsModel.starPercents)),
                        Flexible(child: buildStar(starLevel: 1, starPercents: ratingsModel.starPercents)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 8, bottom: 12),
            // decoration: BoxDecoration(
            //   color: Colors.transparent,
            //   border: Border.all(color: Colors.blue),
            // ),
            child: Divider(),
          ),
          Container(
            child: Row(
              children: [
                Container(
                  width: 3,
                  height: 12,
                  margin: EdgeInsets.only(right: 2),
                  decoration: const BoxDecoration(
                    color: Color(0xFFE44554),
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                  ),
                ),
                Text(
                  starTitle,
                  style: TextStyle(
                    color: themeProvider.subtitleColor,
                    fontSize: 14,
                    fontFamily: 'PingFang SC',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Spacer(),
                NRatingStars(
                  valueVN: ratingsStarVN,
                  onChanged: onRatings,
                  starSize: 18,
                  starSpacing: 6,
                ),
                SizedBox(width: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStar({required int starLevel, required Map<int, double> starPercents}) {
    final percent = starPercents[starLevel] ?? 0;
    var percentStr = "${(percent * 100).toStringAsFixed(1)}%";
    // percentStr = "99.99%";

    final totalItems = List.generate(5, (i) => i);
    return Row(
      children: [
        Row(
          children: totalItems.map((e) {
            final i = totalItems.indexOf(e);
            final hide = starLevel < (totalItems.length - i);
            return AnimatedOpacity(
              opacity: hide ? 0 : 0.6,
              duration: Duration.zero,
              child: Container(
                padding: EdgeInsets.only(left: 2),
                child: Image.asset(
                  Assets.imagesIcRatingStarSelected,
                  width: 10,
                  height: 10,
                  color: Color(0xFFE44554),
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(width: 4),
        Expanded(
          child: Container(
            // decoration: BoxDecoration(
            // border: Border.all(color: Colors.blue),
            // borderRadius: BorderRadius.all(Radius.circular(2)),
            // ),
            child: Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    minHeight: 4,
                    backgroundColor: Color(0xFFDEDEDE),
                    color: Color(0xFFE44554),
                    value: percent,
                    borderRadius: const BorderRadius.all(Radius.circular(2)),
                  ),
                ),
                SizedBox(width: 4),
                Container(
                  width: 40,
                  child: Text(
                    percentStr,
                    style: TextStyle(
                      color: themeProvider.subtitleColor,
                      fontSize: 9.5,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 1,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// 点星评价
  onRatings(double v) async {
    // if (!Global.isLogged) {
    //   initData();
    //   Navigator.pushNamed(context, AppRouter.login);
    //   return;
    // }

    final modelNew = await widget.onRequestRatings(context, v);
    myScore = modelNew.myScore ?? 0;
    starMap = modelNew.scoreTimes?.ratingsMap ?? {};
    ratingsStarVN.value = myScore.toDouble();
    setState(() {});
    widget.onStarChanged?.call(modelNew);
    // DLog.d([ratingsInfoModel.toJson(), widget.item.scoreTimes!.toJson()]);
  }
}
