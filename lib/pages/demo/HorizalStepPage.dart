import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_horizal_step.dart';
import 'package:flutter_templet_project/basicWidget/n_section_box.dart';
import 'package:flutter_templet_project/enum/match/match_stage_enum.dart';

class HorizalStepPage extends StatefulWidget {
  const HorizalStepPage({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<HorizalStepPage> createState() => _HorizalStepPageState();
}

class _HorizalStepPageState extends State<HorizalStepPage> {
  final scrollController = ScrollController();

  @override
  void didUpdateWidget(covariant HorizalStepPage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$widget"),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    final seedColor = Theme.of(context).colorScheme.primary;
    final items = MatchStageEnum.values.reversed.toList();

    return Scrollbar(
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            NSectionBox(
              title: "比赛阶段",
              child: NHorizalStep(
                items: items,
                itemHeaderBuilder: (_, i, bool isSelected) {
                  Color unselecedColor = Colors.grey;
                  final currColor = isSelected ? seedColor : unselecedColor;

                  final e = items[i];
                  final title = e.name.toUpperCase();
                  final subtitle = e.teamDesc;
                  return buildItem(
                    text: title,
                    style: TextStyle(
                      color: currColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                },
                itemFooterBuilder: (_, i, bool isSelected) {
                  Color unselecedColor = Colors.grey;
                  final currColor = isSelected ? seedColor : unselecedColor;

                  final e = items[i];
                  final title = e.name;
                  final subtitle = e.teamDesc.replaceAll(" ", "");
                  return buildItem(
                    text: subtitle,
                    style: TextStyle(
                      color: currColor,
                      fontSize: 13,
                    ),
                  );
                },
              ),
            ),
          ]
              .map((e) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: e,
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget buildItem({required String text, TextStyle? style}) {
    return Container(
      decoration: BoxDecoration(
        // color: currColor,
        // border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: Text(
        text,
        style: style,
        maxLines: 1,
      ),
    );
  }
}
