import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_autocomplete_options_view.dart';
import 'package:flutter_templet_project/extension/rich_text_ext.dart';
import 'package:flutter_templet_project/mixin/safe_set_state_mixin.dart';

/// 自动填充搜索框
class NAutocompleteSearch<T extends Object> extends StatefulWidget {
  const NAutocompleteSearch({
    super.key,
    this.controller,
    this.onChanged,
    required this.items,
    this.fieldViewBuilder,
    required this.displayStringForOption,
    required this.optionsBuilder,
    this.optionsItemBuilder,
    this.onSelected,
  });

  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  final List<T> items;
  final AutocompleteFieldViewBuilder? fieldViewBuilder;
  final String Function(T option) displayStringForOption;
  final FutureOr<Iterable<T>> Function(TextEditingValue textEditingValue) optionsBuilder;
  final IndexedWidgetBuilder? optionsItemBuilder;

  final ValueChanged<T>? onSelected;

  @override
  State<NAutocompleteSearch<T>> createState() => _NAutocompleteSearchState<T>();
}

class _NAutocompleteSearchState<T extends Object> extends State<NAutocompleteSearch<T>> with SafeSetStateMixin {
  var _textEditingValue = TextEditingValue();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant NAutocompleteSearch<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<T>(
      displayStringForOption: widget.displayStringForOption,
      fieldViewBuilder: widget.fieldViewBuilder ?? buildFieldView,
      onSelected: widget.onSelected,
      optionsBuilder: (TextEditingValue textEditingValue) {
        _textEditingValue = textEditingValue;
        final text = textEditingValue.text;
        if (text.isEmpty || widget.items.isEmpty) {
          return Iterable<T>.empty();
        }

        return widget.optionsBuilder(textEditingValue);
        // final result = packages.where((e) => (e.name ?? "").toLowerCase().contains(text.toLowerCase())).toList();
        // return result;
      },
      optionsViewBuilder: (context, onSelected, options) {
        return NAutocompleteOptionsView<T>(
          displayStringForOption: widget.displayStringForOption,
          onSelected: onSelected,
          options: options,
          maxHeight: 300,
          itemBuilder: (context, index) {
            final option = options.elementAt(index);

            final name = widget.displayStringForOption(option);
            final query = _textEditingValue.text;

            return GestureDetector(
              onTap: () => onSelected(option),
              child: widget.optionsItemBuilder?.call(context, index) ??
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 50,
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 8),
                                  // decoration: BoxDecoration(
                                  //   border: Border.all(color: Colors.blue),
                                  // ),
                                  child: Icon(Icons.search, color: Colors.grey, size: 22),
                                ),
                                Container(
                                  // decoration: BoxDecoration(
                                  //   border: Border.all(color: Colors.blue),
                                  // ),
                                  child: Text.rich(
                                    TextSpan(
                                      children: RichTextExt.createTextSpans(
                                        text: name ?? "",
                                        textTaps: [query],
                                        linkStyle: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Divider(indent: 16),
                    ],
                  ),
            );
          },
        );
      },
    );
  }

  Widget buildFieldView(
    BuildContext context,
    TextEditingController controller,
    FocusNode focusNode,
    VoidCallback onFieldSubmitted,
  ) {
    final controllerNew = widget.controller ?? controller;
    final border = UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFE4E4E4), width: 1), // 聚焦状态颜色
    );

    return TextField(
      textInputAction: TextInputAction.next,
      // style: const TextStyle(color: Colors.white),
      controller: controllerNew,
      focusNode: focusNode,
      // onFieldSubmitted: (String value) {
      //   debugPrint("Field: $value");
      //   onFieldSubmitted();
      // },
      onChanged: widget.onChanged,
      onEditingComplete: () {
        debugPrint("onEditingComplete: ${controller.text}");
        // final filters = Get.routeTree.routes.where((e) => e.name == textEditingController.text);
        // if (filters.isNotEmpty) {
        //   widget.onSelected(OptionModel(name: textEditingController.text));
        // }
      },
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(10),
        filled: false,
        border: border,
        enabledBorder: border,
        focusedBorder: border,
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
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: controllerNew,
          builder: (context, textEditingValue, child) {
            final value = textEditingValue.text;
            if (value.isEmpty) {
              return SizedBox();
            }
            return IconButton(
              onPressed: () {
                controllerNew.clear();
              },
              icon: Icon(Icons.cancel, color: Colors.grey),
            );
          },
        ),
      ),
    );
  }
}
