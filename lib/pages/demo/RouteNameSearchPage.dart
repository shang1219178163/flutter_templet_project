import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_autocomplete_search.dart';

import 'package:flutter_templet_project/pages/tabBar_tabBarView_demo.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

class RouteNameSearchPage extends StatefulWidget {
  RouteNameSearchPage({
    Key? key,
    this.title,
    this.hideAppBar = false,
  }) : super(key: key);

  final String? title;

  final bool hideAppBar;

  @override
  _RouteNameSearchPageState createState() => _RouteNameSearchPageState();
}

class _RouteNameSearchPageState extends State<RouteNameSearchPage> {
  final _params = <ParamModel>[
    ParamModel(name: "fieldViewBuilder", isOpen: false),
  ];

  var _tuples = <OptionModel>[];

  final textFieldVN = ValueNotifier("");

  /// 高亮样式
  final TextStyle lightTextStyle = const TextStyle(
    color: Colors.blue,
    fontWeight: FontWeight.bold,
  );

  @override
  void initState() {
    super.initState();

    _tuples = tuples
        .map((e) => OptionModel(
              name: e.item1,
              children: e.item2.map((e) => OptionModel(name: e.item1, desc: e.item2)).toList(),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.hideAppBar
          ? null
          : AppBar(
              title: Text(widget.title ?? "$widget"),
            ),
      body: CustomScrollView(
        slivers: [
          ...buildHeader(),
          NAutocompleteSearch(
            displayStringForOption: (option) {
              return option.name ?? "";
            },
            optionsBuilder: (TextEditingValue textEditingValue) {
              final query = textEditingValue.text;

              final items = _tuples.expand((e) => e.children).toList();
              final result = items.where((e) => e.name.toLowerCase().contains(query.toLowerCase())).toList();
              return result;
            },
            onSelected: (e) {
              debugPrint('onChoosed: ${e.name}');
              Get.toNamed(e.name, arguments: e.toJson());
            },
          ),
        ].map((e) => SliverToBoxAdapter(child: e)).toList(),
      ),
    );
  }

  List<Widget> buildHeader() {
    return [
      // buildExpandColor(),
      buildExpandMenu(),
      // Divider(),
    ];
  }

  var colors = Colors.primaries;
  // final selectedColor = ValueNotifier(Colors.lightBlue);
  final selectedColor = Colors.lightBlue.vn;

  Widget buildExpandColor() {
    return ExpansionTile(
      leading: Icon(
        Icons.color_lens,
        color: selectedColor.value,
      ),
      title: Text(
        '颜色',
        style: TextStyle(color: selectedColor.value),
      ),
      initiallyExpanded: false,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: colors.map((e) {
              return InkWell(
                onTap: () {
                  selectedColor.value = e;
                  setState(() {});
                },
                child: Container(
                  width: 40,
                  height: 40,
                  color: e,
                  child: selectedColor.value == e
                      ? Icon(
                          Icons.done,
                          color: Colors.white,
                        )
                      : null,
                ),
              );
            }).toList(),
          ),
        )
      ],
    );
  }

  Widget buildExpandMenu() {
    return Theme(
      data: ThemeData(
        dividerColor: Colors.transparent,
      ),
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: 10),
        leading: Icon(
          Icons.ac_unit,
          color: selectedColor.value,
        ),
        title: Text(
          '配置',
          style: TextStyle(color: selectedColor.value),
        ),
        initiallyExpanded: false,
        children: <Widget>[
          Column(
            children: _params
                .map((e) => ListTile(
                      title: Text(e.name),
                      trailing: Switch(
                        onChanged: (bool value) {
                          e.isOpen = value;
                          setState(() {});
                        },
                        value: e.isOpen,
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class OptionModel {
  OptionModel({
    required this.name,
    this.desc = "",
    this.children = const [],
  });

  String name;
  String? desc;

  List<OptionModel> children;

  static OptionModel? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }
    return OptionModel(
      name: json['name'],
      desc: json['desc'],
      children: List<OptionModel>.from((json["children"] ?? []).map((e) => OptionModel.fromJson(e))),
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['desc'] = desc;
    data['children'] = children.map((v) => v.toJson()).toList();
    return data;
  }

  @override
  String toString() {
    return '$this ${toJson()}';
  }
}

class ParamModel {
  ParamModel({
    this.name = '',
    this.isOpen = false,
  });

  String name;
  bool isOpen;

  @override
  String toString() {
    return '$this{ name: $name, isOpen: $isOpen, }';
  }
}
