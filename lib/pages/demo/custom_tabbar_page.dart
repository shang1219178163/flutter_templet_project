import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_slidable_tabbar.dart';

import 'package:flutter_templet_project/util/theme/app_color.dart';
import 'package:get/get.dart';

class CustomTabbarPage extends StatefulWidget {
  const CustomTabbarPage({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<CustomTabbarPage> createState() => _CustomTabbarPageState();
}

class _CustomTabbarPageState extends State<CustomTabbarPage> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final scrollController = ScrollController();

  final tabItems = <Map<String, dynamic>>[
    {
      "i": 0,
      "title": "全部",
      "bg": "assets/images/bg_tab_left.png",
    },
    {
      "i": 1,
      "title": "选项1",
      "bg": "assets/images/bg_tab_center.png",
    },
    {
      "i": 2,
      "title": "选项2",
      "bg": "assets/images/bg_tab_right.png",
    },
  ];

  final indexVN = ValueNotifier(0);

  final sportTypes = [
    OutlineTabbarModel(label: "全部预测", value: "all", tabBg: ""),
    OutlineTabbarModel(label: "足球预测", value: "football", tabBg: ""),
    OutlineTabbarModel(label: "篮球预测", value: "basketball", tabBg: ""),
  ];

  @override
  void didUpdateWidget(covariant CustomTabbarPage oldWidget) {
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
    return Scrollbar(
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildCustomTabbar(
              onChanged: (i) {
                DLog.d("buildCustomTabbar $i");
              },
            ),
            OutlineTabbar(
              models: sportTypes,
              initialModel: sportTypes.first,
              onChanged: (v) {},
            ),
            NSlidableTabbar(
              items: List.generate(3, (i) => "选项$i"),
              onChanged: (int v) {
                DLog.d(v);
              },
            ),
          ].map((e) {
            return Container(
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 10),
              child: e,
            );
          }).toList(),
        ),
      ),
    );
  }

  /// 自定义tabbar
  Widget buildCustomTabbar({required ValueChanged<int> onChanged}) {
    final selectedTextStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.red,
    );

    final unselectedTextStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: Colors.black54,
    );
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Container(
          height: 44,
          decoration: BoxDecoration(
            color: AppColor.bgColorF7F7F7,
            border: Border.all(color: Colors.blue),
          ),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Row(
                children: [
                  ...tabItems.map(
                    (e) {
                      final i = e["i"];
                      final isSelected = indexVN.value == i;

                      return Expanded(
                        child: SizedBox(
                          height: 44,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              if (isSelected)
                                Positioned(
                                  left: 0,
                                  top: 0,
                                  bottom: 0,
                                  right: 0,
                                  child: SizedBox(
                                    width: 44,
                                    child: Image.asset(
                                      e["bg"],
                                      fit: BoxFit.fill,
                                      // height: 44,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              GestureDetector(
                                onTap: () {
                                  indexVN.value = i;
                                  setState(() {});
                                  onChanged(indexVN.value);
                                },
                                child: Container(
                                  width: constraints.maxWidth / tabItems.length,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    // border: Border.all(color: Colors.blue),
                                  ),
                                  child: Text(
                                    e["title"],
                                    maxLines: 1,
                                    style: isSelected ? selectedTextStyle : unselectedTextStyle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class OutlineTabbar extends StatefulWidget {
  const OutlineTabbar({
    super.key,
    required this.models,
    required this.initialModel,
    required this.onChanged,
    this.height,
    this.radius,
    this.itemPadding,
    this.selectedLabelStyle,
    this.unselectedLabelStyle,
  });

  final List<OutlineTabbarModel> models;
  final OutlineTabbarModel initialModel;

  final ValueChanged<OutlineTabbarModel> onChanged;

  /// default 24
  final double? height;

  /// default 4
  final double? radius;

  /// default EdgeInsets.symmetric(horizontal: 5, vertical: 2)
  final EdgeInsets? itemPadding;
  final TextStyle? selectedLabelStyle;
  final TextStyle? unselectedLabelStyle;

  @override
  State<OutlineTabbar> createState() => _OutlineTabbarState();
}

class _OutlineTabbarState extends State<OutlineTabbar> {
  late var current = widget.initialModel.value;

  @override
  void didUpdateWidget(covariant OutlineTabbar oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height ?? 30,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, i) {
          final e = widget.models[i];
          final isSelected = e.value == current;
          final textStyle = isSelected ? widget.selectedLabelStyle : widget.unselectedLabelStyle;

          final textColorDefault = isSelected ? Color(0xffE91025) : Color(0xff7C7C85);
          final textColor = textStyle?.color ?? textColorDefault;

          return GestureDetector(
            onTap: () {
              if (current == e.value) {
                return;
              }
              current = e.value;
              setState(() {});
              widget.onChanged(e);
            },
            child: Container(
              padding: widget.itemPadding ?? EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                border: Border.all(color: textColor, width: 1),
                borderRadius: BorderRadius.all(Radius.circular(widget.radius ?? 4.0)),
              ),
              alignment: Alignment.center,
              child: Text(
                e.label,
                style: textStyle ?? TextStyle(color: textColorDefault),
              ),
            ),
          );
        },
        separatorBuilder: (context, i) {
          final e = widget.models[i];
          return SizedBox(width: 6);
        },
        itemCount: widget.models.length,
      ),
    );
  }
}

class OutlineTabbarModel {
  OutlineTabbarModel({
    required this.label,
    required this.value,
    required this.tabBg,
  });

  String label;
  String value;
  String tabBg;

  Map<String, dynamic> toJson() {
    return {
      "label": label,
      "value": value,
      "tabBg": tabBg,
    };
  }

  @override
  String toString() {
    return "$runtimeType: ${toJson()}";
  }
}
