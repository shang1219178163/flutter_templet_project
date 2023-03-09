
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_templet_project/basicWidget/nn_autocomplete_options_view.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:flutter_templet_project/extension/list_ext.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:flutter_templet_project/pages/tabBar_tabBarView_demo.dart';


class AutocompleteDemo extends StatefulWidget {

  final String? title;

  AutocompleteDemo({ Key? key, this.title}) : super(key: key);
  
  @override
  _AutocompleteDemoState createState() => _AutocompleteDemoState();
}

class _AutocompleteDemoState extends State<AutocompleteDemo>{

  final _textEditingController = TextEditingController();
  var _textEditingValue = TextEditingValue();

  var _params = <ParamModel>[
    ParamModel(name: "fieldViewBuilder", isOpen: false),
  ];

  var _tuples = <OptionModel>[];

  final textFieldVN = ValueNotifier("");

  @override
  void initState() {
    _tuples = tuples.map((e) => OptionModel(
      name: e.item1,
      children: e.item2.map((e) => OptionModel(
          name: e.item1,
          desc: e.item2
      )).toList(),)
    ).toList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("_AutocompleteDemoState build");

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: CustomScrollView(
        slivers: [
          ..._buildHeader(),
          Autocomplete<OptionModel>(
            displayStringForOption: (option) => option.name,
            fieldViewBuilder: _params[0].isOpen ? _buildFieldView : _buildFieldViewDefault,
            onSelected: onChoosed,
            optionsBuilder: _buildOptions,
            // optionsViewBuilder: _buildOptionsView,
            optionsViewBuilder: (context,  onSelected, options) {

              return NNAutocompleteOptionsView<OptionModel>(
                displayStringForOption: (option) => option.name,
                onSelected: onSelected,
                options: options,
                maxOptionsHeight: 300,
                cellBuilder: (context, index) {
                  final option = options.elementAt(index);

                  final str = option.name;
                  var textWidget = Text.rich(str.formSpan(
                      _textEditingValue.text,
                      highlightStyle: lightTextStyle
                  ),);
                  textWidget = Text.rich(formSpan(str, _textEditingValue.text,));

                  return _buildItem(
                    onTap: () => onSelected(option),
                    text: textWidget,
                  );
                },
              );
            },
          ),
        ].map((e) => SliverToBoxAdapter(child: e,)).toList(),
      )
    );
  }

  _buildHeader() {
    return [
      Column(
        children: _params.map((e) => ListTile(
          title: Text(e.name),
          trailing: Switch(
            onChanged: (bool value) {
              e.isOpen = value;
              setState(() {});
            },
            value: e.isOpen,
          ),
        )).toList(),
      ),
      Divider(),
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

  void onChoosed(OptionModel val) {
    print('onChoosed: ${val.name}');
    Get.toNamed(val.name, arguments: val.desc);
  }

  Widget _buildOptionsView(
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
                itemBuilder: ( _ , index) {

                  final option = options.elementAt(index);
                  final str = option.name;

                  var textWidget = Text.rich(str.formSpan(
                      _textEditingValue.text,
                      highlightStyle: lightTextStyle
                    ),
                  );
                  textWidget = Text.rich(formSpan(str, _textEditingValue.text,));
                  return _buildItem(
                    onTap: () => onSelected(option),
                    text: textWidget,
                  );

                  return InkWell(
                    onTap: () => onSelected(option),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      decoration: BoxDecoration(
                        // color: index % 2 == 0 ? Colors.green : Colors.yellow,
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search, color: Colors.grey, size: 22),
                          SizedBox(width: 5,),
                          textWidget
                        ],
                      ),
                    ),
                  );
                }
            ),
          ),
      ),
    );
  }

  Widget _buildFieldViewDefault(
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
        print("Field: " + value);
        onFieldSubmitted();
      },
      onChanged: (val){
        print("onChanged: " + val);
        textFieldVN.value = val;
      },
      onEditingComplete: (){
        print("onEditingComplete: " + textEditingController.text);
      },
      decoration: _buildInputDecoration(
        textEditingController: textEditingController,
      ),
    );
  }

  Widget _buildFieldView(
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
        print("Field: " + value);
        onFieldSubmitted();
      },
      validator: (String? value) {
        // if (!foodTags.contains(value)) {
        //   return 'Nothing selected.';
        // }
        return "null";
      },
      decoration: _buildInputDecoration(
        textEditingController: textEditingController,
        hasEnabledBorder: true
      ),
    );
  }

  /// 输入框修饰器
  _buildInputDecoration({
    required TextEditingController textEditingController,
    bool hasEnabledBorder = false,
    InputBorder? enabledBorder = null
  }) {
    final enabledBorderWidget = enabledBorder ?? (!hasEnabledBorder ? null : OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(
          width: 1.5,
          color: Colors.lightBlue
      ),
    ));

    return InputDecoration(
      contentPadding: const EdgeInsets.all(10),
      ///设置输入文本框的提示文字
      ///输入框获取焦点时 并且没有输入文字时
      hintText: "请输入用户名",
      ///设置输入文本框的提示文字的样式
      hintStyle: TextStyle(color: Colors.grey,textBaseline: TextBaseline.ideographic,),
      ///输入文字前的小图标
      prefixIcon: Icon(Icons.search),
      ///输入文字后面的小图标
      suffixIcon: ValueListenableBuilder<String>(
        valueListenable: textFieldVN,
        builder: (context, value, child) {
          return value.length == 0 ? SizedBox() : IconButton(
              onPressed: () => textEditingController.clear(),
              icon: Icon(Icons.close, color: Colors.grey)
          );
        }
      ),
      enabledBorder: enabledBorderWidget,
    );
  }

  /// 高亮样式
  final TextStyle lightTextStyle = const TextStyle(
    color: Colors.blue,
    fontWeight: FontWeight.bold,
  );

  InlineSpan formSpan(String str, String pattern) {
    final regexp = RegExp(pattern, caseSensitive: false);
    final match = regexp.firstMatch(str);
    final matchedText = match?.group(0);
    // print("matchedText: $str $pattern $matchedText");
    if (matchedText == null) {
      return TextSpan(children: [ TextSpan(text: str) ]);
    }

    int index = str.indexOf(matchedText);
    int endIndex = index + matchedText.length;

    final sub = str.substring(index, endIndex);
    final leftStr = str.substring(0, index);
    final rightStr = str.substring(endIndex);

    return TextSpan(children: [
      TextSpan(text: leftStr),
      TextSpan(text: sub, style: lightTextStyle),
      TextSpan(text: rightStr),
    ]);
  }

  _buildItem({required VoidCallback onTap, required Text text}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          // color: index % 2 == 0 ? Colors.green : Colors.yellow,
        ),
        child: Row(
          children: [
            Icon(Icons.search, color: Colors.grey, size: 22),
            SizedBox(width: 5,),
            text
          ],
        ),
      ),
    );
  }

}

class OptionModel {
  OptionModel({
    this.name = "",
    this.desc = "",
    this.children = const [],
  });

  String name;
  String desc;

  List<OptionModel> children;

  @override
  String toString() {
    return '$this{ name: $name, desc: $desc, children: $children, }';
  }
}


class ParamModel {
  ParamModel({
    this.name = "",
    this.isOpen = false,
  });

  String name;
  bool isOpen;

  @override
  String toString() {
    return '$this{ name: $name, isOpen: $isOpen, }';
  }
}

