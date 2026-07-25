import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_autocomplete_search.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/pages/tabBar_tabBarView_demo.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

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

  final textFieldVN = ValueNotifier("");

  /// 每次从 tuples 读取，避免热重载后仍用旧缓存
  List<OptionModel> get _routeOptions {
    return tuples
        .expand((e) => e.item2)
        .map((e) => OptionModel(name: e.item1, desc: e.item2))
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
            displayStringForOption: (option) => option.name,
            optionsBuilder: (TextEditingValue textEditingValue) {
              final query = textEditingValue.text.trim().toLowerCase();
              if (query.isEmpty) {
                return const <OptionModel>[];
              }
              return _routeOptions.where((e) {
                final name = e.name.toLowerCase();
                final desc = (e.desc ?? '').toLowerCase();
                return name.contains(query) || desc.contains(query);
              }).toList();
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
    final colorScheme = Theme.of(context).colorScheme;
    return Theme(
      // 保留当前明暗主题，仅去掉分割线；勿用 ThemeData() 重置为浅色
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: 10),
        collapsedTextColor: colorScheme.onSurface,
        textColor: colorScheme.onSurface,
        iconColor: colorScheme.primary,
        collapsedIconColor: colorScheme.primary,
        leading: Icon(
          Icons.ac_unit,
          color: colorScheme.primary,
        ),
        title: Text(
          '配置',
          style: TextStyle(
            color: colorScheme.onSurface,
          ),
        ),
        initiallyExpanded: false,
        children: <Widget>[
          Column(
            children: _params.map((e) {
              return SwitchListTile(
                activeColor: colorScheme.primary,
                title: Text(
                  e.name,
                  style: TextStyle(color: colorScheme.onSurface),
                ),
                value: e.isOpen,
                onChanged: (bool value) {
                  e.isOpen = value;
                  setState(() {});
                },
              );
            }).toList(),
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

  static OptionModel? fromJson(Map<String, dynamic> json) {
    return OptionModel(
      name: json['name'],
      desc: json['desc'],
      children: List<OptionModel>.from(
        ((json["children"] as List<dynamic>?) ?? <dynamic>[]).map(
          (e) => OptionModel.fromJson(e as Map<String, dynamic>),
        ),
      ),
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
