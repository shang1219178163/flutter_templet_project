import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_flex_separated.dart';
import 'package:flutter_templet_project/basicWidget/n_section_box.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:get/get.dart';

class NFlexSeparatedDemo extends StatefulWidget {
  const NFlexSeparatedDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<NFlexSeparatedDemo> createState() => _NFlexSeparatedDemoState();
}

class _NFlexSeparatedDemoState extends State<NFlexSeparatedDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final scrollController = ScrollController();

  Map<String, dynamic> arguments = Get.arguments ?? <String, dynamic>{};

  /// id
  late final id = arguments["id"];

  @override
  void didUpdateWidget(covariant NFlexSeparatedDemo oldWidget) {
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
                'done',
              ]
                  .map((e) => TextButton(
                        child: Text(
                          e,
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () => debugPrint(e),
                      ))
                  .toList(),
            ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Scrollbar(
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            buildSection3(),
          ],
        ),
      ),
    );
  }

  Widget buildSection3() {
    final children = List.generate(
        4,
        (index) => Container(
              decoration: BoxDecoration(
                color: Colors.green,
                // border: Border.all(color: Colors.blue),
              ),
              child: NText("选项_$index"),
            )).toList();

    Widget separated = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: VerticalDivider(
        color: Colors.red,
        width: 1,
        indent: 0,
        endIndent: 0,
      ),
    );
    return Container(
      // color: Colors.green,
      child: Column(
        children: [
          NSectionBox(
            title: "ListView.separated",
            child: Container(
              height: 20,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
              ),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, i) => children[i],
                separatorBuilder: (_, i) => separated,
                itemCount: children.length,
              ),
            ),
          ),
          NSectionBox(
            title: "NFlexSeparated - separatedBuilder",
            child: Container(
              height: 30,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
              ),
              child: NFlexSeparated(
                direction: Axis.horizontal,
                spacing: 60,
                separatedBuilder: (i) {
                  final spacing = (i + 1) * 16.0;
                  return Container(
                    width: spacing,
                    color: Colors.yellow,
                    alignment: Alignment.center,
                    child: NText(
                      spacing.toInt().toString(),
                      style: TextStyle(fontSize: 13),
                    ),
                  );
                  // return separated;
                },
                children: children,
              ),
            ),
          ),
          NSectionBox(
            title: "NFlexSeparated - spacing: 16",
            child: Container(
              height: 30,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
              ),
              alignment: Alignment.center,
              child: NFlexSeparated(
                direction: Axis.horizontal,
                spacing: 16,
                // separatedBuilder: (i) {
                //   return Container(color: Colors.cyan, width: 12);
                //   // return separated;
                // },
                children: children,
              ),
            ),
          ),
          NSectionBox(
            title: "NFlexSeparated - vertical - separatedBuilder",
            child: IntrinsicWidth(
              child: NFlexSeparated(
                direction: Axis.vertical,
                spacing: 60,
                separatedBuilder: (i) {
                  final spacing = (i + 1) * 16.0;
                  return Container(
                    height: spacing,
                    color: Colors.yellow,
                    alignment: Alignment.center,
                    child: NText(
                      spacing.toInt().toString(),
                      style: TextStyle(fontSize: 13),
                    ),
                  );
                  // return separated;
                },
                children: children,
              ),
            ),
          ),
          NSectionBox(
            title: "NFlexSeparated - vertical - spacing: 16",
            child: IntrinsicWidth(
              child: NFlexSeparated(
                direction: Axis.vertical,
                separatedBuilder: (i) {
                  final spacing = 16.0;
                  return Container(
                    height: spacing,
                    color: Colors.yellow,
                    alignment: Alignment.center,
                    child: NText(
                      spacing.toInt().toString(),
                      style: TextStyle(fontSize: 13),
                    ),
                  );
                  // return separated;
                },
                children: children,
              ),
            ),
          ),
          NSectionBox(
            title: "NFlexSeparated - horizontal",
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
              ),
              child: IntrinsicHeight(
                child: buildFlexSeparated(direction: Axis.horizontal),
              ),
            ),
          ),
          NSectionBox(
            title: "NFlexSeparated - vertical",
            child: Container(
              height: 400,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
              ),
              child: IntrinsicWidth(
                child: buildFlexSeparated(direction: Axis.vertical),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 带分隔的 Flex
  Widget buildFlexSeparated({
    required Axis direction,
    Alignment? textAlignment = Alignment.center,
    double spacing = 0,
    Widget Function(int index)? separatedBuilder,
  }) {
    return NFlexSeparated(
      direction: direction,
      // crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      separatedBuilder: separatedBuilder ??
          (i) {
            final spacing = 16.0 * (i + 1);
            return Container(
              width: direction == Axis.horizontal ? spacing : null,
              height: direction == Axis.horizontal ? null : spacing,
              color: Colors.yellow,
              alignment: Alignment.center,
              child: NText(
                spacing.toInt().toString(),
                style: TextStyle(fontSize: 13),
              ),
            );
          },
      children: [
        Flexible(
          flex: 1,
          child: Container(
            color: Colors.red,
            alignment: textAlignment,
            child: Text(
              "flex: 1",
              style: TextStyle(fontSize: 13),
            ),
          ),
        ),
        Flexible(
          flex: 2,
          child: Container(
            color: Colors.green,
            alignment: textAlignment,
            child: Text(
              "flex: 2",
              style: TextStyle(fontSize: 13),
            ),
          ),
        ),
        Flexible(
          flex: 3,
          child: Container(
            color: Colors.blue,
            alignment: textAlignment,
            child: Text(
              "flex: 3",
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            color: Colors.purple,
            alignment: textAlignment,
            child: Text(
              "flex: 1",
              style: TextStyle(fontSize: 13),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildGradientBorder() {
    var borderRadius = BorderRadius.circular(15);

    return Container(
      height: 100,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        gradient: LinearGradient(
          colors: [
            Colors.red,
            Colors.green,
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(1.5),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            color: Colors.white,
          ),
          child: Center(
            child: Text('Enter further widgets here'),
          ),
        ),
      ),
    );
  }
}
