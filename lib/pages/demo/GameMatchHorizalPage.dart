//
//  GameMatchHorizalPage.dart
//  flutter_templet_project
//
//  Created by shang on 2026/5/22 18:41.
//  Copyright © 2026/5/22 shang. All rights reserved.
//

import 'dart:math';

import 'package:flutter/material.dart';

class GameMatchHorizalPage extends StatefulWidget {
  const GameMatchHorizalPage({super.key});

  @override
  State<GameMatchHorizalPage> createState() => _GameMatchHorizalPageState();
}

class _GameMatchHorizalPageState extends State<GameMatchHorizalPage> {
  late final List<List<BracketMatch>> rounds;

  static const double cardWidth = 143;
  static const double cardHeight = 42;

  static const double teamGap = 12;
  static const double matchGap = 44;

  static const double roundWidth = cardWidth + 40;
  static const double leftPadding = 16;

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    rounds = buildMockBracket();

    _calculateAllCenterY();
  }

  @override
  Widget build(BuildContext context) {
    final totalWidth = rounds.length * roundWidth + 300;

    final totalHeight = _calculateTotalHeight();

    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      appBar: AppBar(title: const Text("淘汰赛")),
      body: InteractiveViewer(
        constrained: false,
        minScale: 0.8,
        maxScale: 2,
        child: SingleChildScrollView(
          controller: scrollController,
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: totalWidth,
            height: totalHeight,
            child: Stack(
              children: [
                CustomPaint(
                  size: Size(totalWidth, totalHeight),
                  painter: BracketPainter(
                    rounds: rounds,
                    cardWidth: cardWidth,
                    cardHeight: cardHeight,
                    roundWidth: roundWidth,
                    leftPadding: leftPadding,
                  ),
                ),
                ..._buildTeamCards(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  /// 计算所有 match centerY
  ///
  void _calculateAllCenterY() {
    ///
    /// 第一轮
    ///
    final firstRound = rounds.first;
    final blockHeight = cardHeight * 2 + teamGap + matchGap;

    for (var i = 0; i < firstRound.length; i++) {
      final match = firstRound[i];

      final topCenter = i * blockHeight + cardHeight / 2;
      debugPrint('topCenter=index=${i},centerY=$topCenter');

      final bottomCenter = topCenter + cardHeight + teamGap;
      match.topCenterY = topCenter;
      match.bottomCenterY = bottomCenter;
      match.centerY = (topCenter + bottomCenter) / 2;
    }

    ///
    /// 后续轮
    ///
    for (var round = 1; round < rounds.length; round++) {
      final currentRound = rounds[round];

      ///
      /// 冠军轮特殊处理
      ///
      if (round == rounds.length - 1) {
        final champion = currentRound.first;
        final finalMatch = rounds[round - 1].first;

        champion.centerY = finalMatch.centerY;
        champion.topCenterY = finalMatch.centerY;
        champion.bottomCenterY = finalMatch.centerY;
        continue;
      }

      for (var i = 0; i < currentRound.length; i++) {
        final current = currentRound[i];
        final topChild = rounds[round - 1][i * 2];
        final bottomChild = rounds[round - 1][i * 2 + 1];

        current.topCenterY = topChild.centerY;
        current.bottomCenterY = bottomChild.centerY;
        current.centerY = (current.topCenterY + current.bottomCenterY) / 2;

        debugPrint('current=$i,,,,${current.toJson()}');
      }
    }
  }

  List<Widget> _buildTeamCards() {
    final widgets = <Widget>[];

    for (var round = 0; round < rounds.length; round++) {
      final matches = rounds[round];

      for (var index = 0; index < matches.length; index++) {
        final match = matches[index];
        final left = leftPadding + round * roundWidth;

        // 冠军
        if (round == rounds.length - 1) {
          widgets.add(
            Positioned(
              left: left,
              top: match.centerY - cardHeight / 2,
              child: TeamCard(
                width: cardWidth,
                height: cardHeight,
                team: match.topTeam,
                selected: match.winner?.id == match.topTeam?.id,
                onTap: () {},
              ),
            ),
          );

          continue;
        }

        // top
        widgets.add(
          Positioned(
            left: left,
            top: match.topCenterY - cardHeight / 2,
            child: TeamCard(
              width: cardWidth,
              height: cardHeight,
              team: match.topTeam,
              selected: match.winner?.id == match.topTeam?.id,
              onTap: () {
                _onSelectWinner(round, index, match.topTeam);
              },
            ),
          ),
        );

        // bottom
        widgets.add(
          Positioned(
            left: left,
            top: match.bottomCenterY - cardHeight / 2,
            child: TeamCard(
              width: cardWidth,
              height: cardHeight,
              team: match.bottomTeam,
              selected: match.winner?.id == match.bottomTeam?.id,
              onTap: () {
                _onSelectWinner(round, index, match.bottomTeam);
              },
            ),
          ),
        );
      }
    }

    return widgets;
  }

  void _onSelectWinner(int round, int matchIndex, Team? team) {
    if (team == null) {
      return;
    }

    setState(() {
      final currentMatch = rounds[round][matchIndex];
      currentMatch.winner = team;

      // 最后一轮
      if (round >= rounds.length - 1) {
        return;
      }

      final nextRound = rounds[round + 1];

      // 冠军轮
      if (round == rounds.length - 2) {
        nextRound.first.topTeam = team;
        nextRound.first.winner = team;
        return;
      }

      final nextMatchIndex = matchIndex ~/ 2;
      final nextMatch = nextRound[nextMatchIndex];
      if (matchIndex.isEven) {
        nextMatch.topTeam = team;
      } else {
        nextMatch.bottomTeam = team;
      }
    });
  }

  double _calculateTotalHeight() {
    final firstRoundCount = rounds.first.length;
    return firstRoundCount * (cardHeight * 2 + teamGap + matchGap);
  }
}

///
/// 连线
///
class BracketPainter extends CustomPainter {
  final List<List<BracketMatch>> rounds;

  final double cardWidth;
  final double cardHeight;
  final double roundWidth;
  final double leftPadding;

  BracketPainter({
    required this.rounds,
    required this.cardWidth,
    required this.cardHeight,
    required this.roundWidth,
    required this.leftPadding,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xff00a67e)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (var round = 0; round < rounds.length - 1; round++) {
      final matches = rounds[round];

      for (var index = 0; index < matches.length; index++) {
        final match = matches[index];
        final startX = leftPadding + round * roundWidth + cardWidth;
        final middleX = startX + 24;
        final nextX = leftPadding + (round + 1) * roundWidth;
        final topY = match.topCenterY;
        final bottomY = match.bottomCenterY;
        final centerY = match.centerY;

        final path = Path()
          ..moveTo(startX, topY)
          ..lineTo(middleX, topY)
          ..moveTo(startX, bottomY)
          ..lineTo(middleX, bottomY)
          ..moveTo(middleX, topY)
          ..lineTo(middleX, bottomY)
          ..moveTo(middleX, centerY)
          ..lineTo(nextX, centerY);

        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

///
/// 球队卡片
///
class TeamCard extends StatelessWidget {
  final double width;
  final double height;

  final Team? team;

  final bool selected;

  final VoidCallback onTap;

  const TeamCard({
    super.key,
    required this.width,
    required this.height,
    required this.team,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: team == null ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: width,
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: selected ? const Color(0xff008a64) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(blurRadius: 8, color: Colors.black.withOpacity(0.08))],
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 22,
              alignment: Alignment.center,
              decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300)),
              child: Text(team?.flag ?? '?', style: const TextStyle(fontSize: 16)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                team?.name ?? '?',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: selected ? Colors.white : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

///
/// Match
///
class BracketMatch {
  Team? topTeam;
  Team? bottomTeam;
  Team? winner;

  late double topCenterY;
  late double bottomCenterY;
  late double centerY;

  BracketMatch({this.topTeam, this.bottomTeam});

  Map<String, dynamic> toJson() {
    return {
      'topTeam': topTeam?.toJson(),
      'bottomTeam': bottomTeam?.toJson(),
      'winner': winner?.toJson(),
      'topCenterY': topCenterY,
      'bottomCenterY': bottomCenterY,
      'centerY': centerY,
    };
  }
}

///
/// Team
///
class Team {
  final String id;
  final String name;
  final String flag;

  Team({required this.id, required this.name, required this.flag});

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'flag': flag};
  }
}

///
/// mock
///
List<List<BracketMatch>> buildMockBracket() {
  final teams = [
    Team(id: "1", name: "中国", flag: ""),
    Team(id: "2", name: "朝鲜", flag: ""),
    Team(id: "3", name: "马来西亚", flag: ""),
    Team(id: "4", name: "澳大利亚", flag: ""),
    Team(id: "5", name: "法国", flag: ""),
    Team(id: "6", name: "德国", flag: ""),
    Team(id: "7", name: "巴西", flag: ""),
    Team(id: "8", name: "阿根廷", flag: ""),

    // Team(id: "9", name: "西班牙", flag: ""),
    // Team(id: "10", name: "葡萄牙", flag: ""),
    // Team(id: "11", name: "英格兰", flag: ""),
    // Team(id: "12", name: "意大利", flag: ""),
    // Team(id: "13", name: "荷兰", flag: ""),
    // Team(id: "14", name: "比利时", flag: ""),
    // Team(id: "15", name: "克罗地亚", flag: ""),
    // Team(id: "16", name: "乌拉圭", flag: ""),
    //
    // Team(id: "17", name: "墨西哥", flag: ""),
    // Team(id: "18", name: "美国", flag: ""),
    // Team(id: "19", name: "加拿大", flag: ""),
    // Team(id: "20", name: "哥伦比亚", flag: ""),
    // Team(id: "21", name: "智利", flag: ""),
    // Team(id: "22", name: "秘鲁", flag: ""),
    // Team(id: "23", name: "瑞士", flag: ""),
    // Team(id: "24", name: "丹麦", flag: ""),
    //
    // Team(id: "25", name: "塞尔维亚", flag: ""),
    // Team(id: "26", name: "波兰", flag: ""),
    // Team(id: "27", name: "瑞典", flag: ""),
    // Team(id: "28", name: "挪威", flag: ""),
    // Team(id: "29", name: "伊朗", flag: ""),
    // Team(id: "30", name: "沙特", flag: ""),
    // Team(id: "31", name: "卡塔尔", flag: ""),
    // Team(id: "32", name: "摩洛哥", flag: ""),
  ];

  final round1 = <BracketMatch>[];
  for (var i = 0; i < teams.length; i += 2) {
    round1.add(BracketMatch(topTeam: teams[i], bottomTeam: teams[i + 1]));
  }

  final totalRounds = (log(teams.length) / log(2)).ceil();
  final result = <List<BracketMatch>>[];
  result.add(round1);
  var count = round1.length ~/ 2;
  while (count > 0) {
    result.add(List.generate(count, (_) => BracketMatch()));
    count ~/= 2;
  }

  // 冠军
  result.add([BracketMatch()]);
  return result;
}
