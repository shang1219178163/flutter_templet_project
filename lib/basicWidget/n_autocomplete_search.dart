import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_autocomplete_options_view.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

/// 自动填充搜索框
class NAutocompleteSearch<T extends Object> extends StatefulWidget {
  const NAutocompleteSearch({
    super.key,
    this.controller,
    this.onChanged,
    this.fieldViewBuilder,
    required this.displayStringForOption,
    required this.optionsBuilder,
    this.optionsItemBuilder,
    this.onSelected,
  });

  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  final AutocompleteFieldViewBuilder? fieldViewBuilder;
  final String Function(T option) displayStringForOption;
  final FutureOr<Iterable<T>> Function(TextEditingValue v) optionsBuilder;
  final IndexedWidgetBuilder? optionsItemBuilder;

  final ValueChanged<T>? onSelected;

  @override
  State<NAutocompleteSearch<T>> createState() => _NAutocompleteSearchState<T>();
}

class _NAutocompleteSearchState<T extends Object> extends State<NAutocompleteSearch<T>> {
  var _textEditingValue = TextEditingValue();
  late final TextEditingController _fallbackController;
  late final FocusNode _focusNode;
  var _fromTap = false;

  TextEditingController get _effectiveController => widget.controller ?? _fallbackController;

  @override
  void initState() {
    super.initState();
    _fallbackController = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _fallbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RawAutocomplete<T>(
      textEditingController: _effectiveController,
      focusNode: _focusNode,
      displayStringForOption: widget.displayStringForOption,
      fieldViewBuilder: widget.fieldViewBuilder ?? buildFieldView,
      onSelected: (option) {
        if (!_fromTap) widget.onSelected?.call(option);
      },
      optionsBuilder: (textEditingValue) {
        _textEditingValue = textEditingValue;
        if (textEditingValue.text.isEmpty) {
          return Iterable<T>.empty();
        }
        return widget.optionsBuilder(textEditingValue);
      },
      optionsViewBuilder: (context, onSelected, options) {
        return NAutocompleteOptionsView<T>(
          displayStringForOption: widget.displayStringForOption,
          onSelected: (option) {
            _fromTap = true;
            widget.onSelected?.call(option);
            onSelected(option);
            _fromTap = false;
          },
          options: options,
          maxHeight: 300,
          itemBuilder: (context, index) {
            if (widget.optionsItemBuilder != null) {
              return widget.optionsItemBuilder!(context, index);
            }
            final name = widget.displayStringForOption(options.elementAt(index));
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: SizedBox(
                    height: 34,
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: Icon(Icons.search, color: Colors.grey, size: 22),
                        ),
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              children: RichTextExt.createTextSpans(
                                text: name,
                                textTaps: [_textEditingValue.text],
                                linkStyle: TextStyle(
                                  color: context.themeData.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(indent: 16),
              ],
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
    final border = UnderlineInputBorder(
      borderSide: Divider.createBorderSide(context, width: 1.0),
    );

    return TextField(
      textInputAction: TextInputAction.next,
      controller: controller,
      focusNode: focusNode,
      onSubmitted: (_) => onFieldSubmitted(),
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(10),
        filled: false,
        border: border,
        enabledBorder: border,
        focusedBorder: border,
        hintText: "请输入关键词",
        hintStyle: const TextStyle(
          color: Colors.grey,
          textBaseline: TextBaseline.ideographic,
        ),
        prefixIcon: const Icon(Icons.search),
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (context, textEditingValue, child) {
            if (textEditingValue.text.isEmpty) {
              return const SizedBox();
            }
            return IconButton(
              onPressed: controller.clear,
              icon: const Icon(Icons.cancel, color: Colors.grey),
            );
          },
        ),
      ),
    );
  }
}
