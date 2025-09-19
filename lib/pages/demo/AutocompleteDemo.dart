import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_autocomplete_options_view.dart';
import 'package:flutter_templet_project/basicWidget/n_pair.dart';
import 'package:flutter_templet_project/extension/change_notifier_ext.dart';
import 'package:flutter_templet_project/extension/rich_text_ext.dart';
import 'package:flutter_templet_project/pages/tabBar_tabBarView_demo.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class AutocompleteDemo extends StatefulWidget {
  AutocompleteDemo({
    Key? key,
    this.title,
    this.hideAppBar = false,
    this.routingCallback,
  }) : super(key: key);

  final String? title;

  final bool hideAppBar;

  final ValueChanged<OptionModel>? routingCallback;

  @override
  _AutocompleteDemoState createState() => _AutocompleteDemoState();
}

class _AutocompleteDemoState extends State<AutocompleteDemo> {
  // final _textEditingController = TextEditingController();
  var _textEditingValue = TextEditingValue();

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
            Autocomplete<OptionModel>(
              displayStringForOption: (option) => option.name,
              fieldViewBuilder: _params[0].isOpen ? buildFieldView : buildFieldViewDefault,
              onSelected: onSelected,
              optionsBuilder: _buildOptions,
              // optionsViewBuilder: _buildOptionsView,
              optionsViewBuilder: (context, onSelected, options) {
                return NAutocompleteOptionsView<OptionModel>(
                  displayStringForOption: (option) => option.name,
                  onSelected: onSelected,
                  options: options,
                  maxHeight: 300,
                  itemBuilder: (context, index) {
                    final option = options.elementAt(index);

                    final name = option.name;
                    final query = _textEditingValue.text;
                    // var textWidget = Text.rich(
                    //   name.firstMatchLight(
                    //     pattern: query,
                    //     lightTextStyle: lightTextStyle,
                    //   ),
                    // );

                    final textWidget = Text.rich(
                      TextSpan(
                        children: RichTextExt.createTextSpans(
                          text: name,
                          textTaps: [query],
                          linkStyle: lightTextStyle,
                        ),
                      ),
                    );

                    return buildItem(
                      onTap: () => onSelected(option),
                      child: textWidget,
                    );
                  },
                );
              },
            ),
            // Image(
            //   image: "img_flutter_3_10.png".toAssetImage(),
            //   colorBlendMode: BlendMode.dst,
            //   color: context.primaryColor,
            // ),
          ].map((e) => SliverToBoxAdapter(child: e)).toList(),
        ));
  }

  buildHeader() {
    return [
      // buildExpandColor(),
      buildExpandMenu(),
      // Divider(),
    ];
  }

  Iterable<OptionModel> _buildOptions(TextEditingValue textEditingValue) {
    _textEditingValue = textEditingValue;
    return _buildFilterTitle(textEditingValue.text);
  }

  Iterable<OptionModel> _buildFilterTitle([String text = ""]) {
    if (text == '') {
      return Iterable<OptionModel>.empty();
    }

    final items = _tuples.expand((e) => e.children).toList();
    final result = items.where((e) => e.name.toLowerCase().contains(text.toLowerCase())).toList();
    return result;
  }

  void onSelected(OptionModel val) {
    if (widget.routingCallback != null) {
      widget.routingCallback?.call(val);
      return;
    }
    // debugPrint('onChoosed: ${val.name}');
    Get.toNamed(val.name, arguments: val.toJson());
  }

  Widget buildOptionsView(
    BuildContext context,
    AutocompleteOnSelected<OptionModel> onSelected,
    Iterable<OptionModel> options,
  ) {
    final items = _buildFilterTitle(_textEditingValue.text);

    return Align(
      alignment: Alignment.topLeft,
      child: Material(
        elevation: 4.0,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          constraints: BoxConstraints(maxHeight: 200),
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (_, index) {
              final option = options.elementAt(index);
              final name = option.name;
              final query = _textEditingValue.text;

              // var textWidget = Text.rich(
              //   name.firstMatchLight(
              //     pattern: query,
              //     lightTextStyle: lightTextStyle,
              //   ),
              // );

              final textWidget = Text.rich(
                TextSpan(
                  children: RichTextExt.createTextSpans(
                    text: name,
                    textTaps: [query],
                    linkStyle: lightTextStyle,
                  ),
                ),
              );

              return buildItem(
                onTap: () => onSelected(option),
                child: textWidget,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildFieldViewDefault(
    BuildContext context,
    TextEditingController textEditingController,
    FocusNode focusNode,
    VoidCallback onFieldSubmitted,
  ) {
    return TextField(
      textInputAction: TextInputAction.next,
      // style: const TextStyle(color: Colors.white),
      controller: textEditingController,
      focusNode: focusNode,
      // onFieldSubmitted: (String value) {
      //   debugPrint("Field: $value");
      //   onFieldSubmitted();
      // },
      onChanged: (val) {
        // debugPrint("onChanged: $val");
        textFieldVN.value = val;
      },
      onEditingComplete: () {
        debugPrint("onEditingComplete: ${textEditingController.text}");
        final filters = Get.routeTree.routes.where((e) => e.name == textEditingController.text);
        if (filters.isNotEmpty) {
          onSelected(OptionModel(name: textEditingController.text));
        }
      },
      decoration: buildInputDecoration(
        textEditingController: textEditingController,
      ),
    );
  }

  Widget buildFieldView(
    BuildContext context,
    TextEditingController textEditingController,
    FocusNode focusNode,
    VoidCallback onFieldSubmitted,
  ) {
    return TextFormField(
      textInputAction: TextInputAction.next,
      // style: const TextStyle(color: Colors.white),
      controller: textEditingController,
      focusNode: focusNode,
      onFieldSubmitted: (String value) {
        debugPrint("Field: $value");
        onFieldSubmitted();
      },
      validator: (String? value) {
        // if (!foodTags.contains(value)) {
        //   return 'Nothing selected.';
        // }
        return "null";
      },
      decoration: buildInputDecoration(
        textEditingController: textEditingController,
        hasEnabledBorder: true,
      ),
    );
  }

  /// 输入框修饰器
  buildInputDecoration({
    required TextEditingController textEditingController,
    bool hasEnabledBorder = false,
    InputBorder? enabledBorder,
  }) {
    final enabledBorderWidget = enabledBorder ??
        (!hasEnabledBorder
            ? null
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(width: 1.5, color: Colors.lightBlue),
              ));

    return InputDecoration(
      contentPadding: const EdgeInsets.all(10),
      //设置输入文本框的提示文字
      //输入框获取焦点时 并且没有输入文字时
      hintText: "请输入关键词",
      //设置输入文本框的提示文字的样式
      hintStyle: TextStyle(
        color: Colors.grey,
        textBaseline: TextBaseline.ideographic,
      ),
      //输入文字前的小图标
      prefixIcon: Icon(Icons.search),
      //输入文字后面的小图标
      suffixIcon: ValueListenableBuilder<String>(
        valueListenable: textFieldVN,
        builder: (context, value, child) {
          if (value.isEmpty) {
            return SizedBox();
          }
          return IconButton(
            onPressed: () {
              textEditingController.clear();
              textFieldVN.value = "";
            },
            icon: Icon(Icons.cancel, color: Colors.grey),
          );
        },
      ),
      enabledBorder: enabledBorderWidget,
    );
  }

  Widget buildItem({
    required VoidCallback onTap,
    required Widget child,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: NPair(
          mainAxisAlignment: MainAxisAlignment.start,
          icon: Icon(Icons.search, color: Colors.grey, size: 22),
          child: child,
        ),
      ),
    );
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
    return '$this{ name: $name, desc: $desc, children: $children, }';
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
