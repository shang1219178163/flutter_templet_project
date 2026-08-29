import 'package:flutter/material.dart';
import 'package:flutter_templet_project/pages/demo/ball/BallTeamView.dart';
import 'package:get/get.dart';

class FootballTeamPage extends StatefulWidget {
  const FootballTeamPage({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<FootballTeamPage> createState() => _FootballTeamPageState();
}

class _FootballTeamPageState extends State<FootballTeamPage> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final scrollController = ScrollController();

  Map<String, dynamic> arguments = Get.arguments ?? <String, dynamic>{};

  /// id
  late final id = arguments["id"];

  @override
  void didUpdateWidget(covariant FootballTeamPage oldWidget) {
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
    return BallTeamView();
  }
}
