import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/basicWidget/n_menu_anchor.dart';
import 'package:flutter_templet_project/basicWidget/n_network_image.dart';
import 'package:flutter_templet_project/basicWidget/refresh_control/cupertino_sliver_refresh_control_ext.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/model/match_member_score_model.dart';
import 'package:get/get.dart';

class CompareToPage extends StatefulWidget {
  const CompareToPage({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<CompareToPage> createState() => _CompareToPageState();
}

class _CompareToPageState extends State<CompareToPage> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final scrollController = ScrollController();

  var players = <PlayerScoreItemModel>[];
  var sortKeys = <String>[
    "id",
    "teamId",
    "shortName",
    "shirtNumber",
    "myScore",
    "scoreTimes",
  ];

  late var sortSelected = sortKeys.first;

  @override
  void initState() {
    super.initState();
    initData().then((v) {
      setState(() {});
    });
  }

  Future<void> initData() async {
    if (players.isNotEmpty) {
      return;
    }
    final str = await rootBundle.loadString("assets/data/football_players.json");
    final map = jsonDecode(str) as Map<String, dynamic>;
    final matchScoreDataModel = MatchMemberScoreDataModel.fromJson(map['data']);
    players = matchScoreDataModel.playerScoreItem ?? [];
    players.sort(comparePlayer);

    sortKeys = players.first.toJson().keys.toList();
  }

  @override
  void didUpdateWidget(covariant CompareToPage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hideApp
          ? null
          : AppBar(
              title: Text("$widget"),
              actions: [
                NMenuAnchor(
                  constraints: BoxConstraints(
                    maxHeight: 400,
                  ),
                  values: sortKeys,
                  initialItem: sortSelected,
                  onChanged: (v) {
                    DLog.d(v);
                    sortSelected = v;
                    players.sort((a, b) {
                      final aValue = a.toJson()[v];
                      final bValue = b.toJson()[v];
                      return bValue.compareTo(aValue);
                    });
                    setState(() {});
                  },
                  cbName: (e) => "$e",
                  equal: (a, b) => a == b,
                ),
              ],
            ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return CustomScrollView(
      slivers: [
        CupertinoSliverRefreshControl(
          builder: CupertinoSliverRefreshControlExt.customRefreshIndicator,
          onRefresh: onRefresh,
        ),
        SliverList.separated(
          itemCount: players.length,
          itemBuilder: (_, index) {
            final e = players[index];
            final avatar = e.logo ?? "";

            final desc = [e.id, e.teamId, e.shirtNumber].join("_");
            return ListTile(
              leading: NNetworkImage(
                url: avatar,
                width: 48,
                height: 48,
              ),
              title: Text(e.shortName ?? ""),
              subtitle: Text(desc),
            );
          },
          separatorBuilder: (_, index) {
            return Divider(indent: 16, endIndent: 16);
          },
        ),
      ],
    );
  }

  Future<void> onRefresh() async {
    DLog.d("开始刷新");
    await Future.delayed(Duration(milliseconds: 1500));
    DLog.d("结束刷新");
  }

  int comparePlayer(
    PlayerScoreItemModel a,
    PlayerScoreItemModel b,
  ) {
    final aTeamId = a.teamId ?? 0;
    final bTeamId = b.teamId ?? 0;
    final com = bTeamId.compareTo(aTeamId);
    if (com != 0) {
      return com;
    }

    final aID = a.id ?? 0;
    final bID = b.id ?? 0;
    return aID.compareTo(bID);
  }

  int compareUserMap(
    Map<String, dynamic> a,
    Map<String, dynamic> b,
  ) {
    final ageA = a['age'] as int? ?? 0;
    final ageB = b['age'] as int? ?? 0;

    final ageCompare = ageB.compareTo(ageA);
    if (ageCompare != 0) {
      return ageCompare;
    }

    final jobA = a['jobNo'] as int? ?? 0;
    final jobB = b['jobNo'] as int? ?? 0;
    return jobB.compareTo(jobA);
  }
}
