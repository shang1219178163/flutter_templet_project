//
//  NnAutocompleteOptionsView.dart
//  flutter_templet_project
//
//  Created by shang on 3/9/23 4:59 PM.
//  Copyright © 3/9/23 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

// typedef OptionWidgetBuilder<T extends Object> = Widget Function(T option);

/// Autocomplete 组件的 optionsViewBuilder 返回视图
class NAutocompleteOptionsView<T extends Object> extends StatefulWidget {
  const NAutocompleteOptionsView({
    Key? key,
    required this.displayStringForOption,
    required this.onSelected,
    required this.options,
    required this.maxHeight,
    this.itemBuilder,
  }) : super(key: key);

  final AutocompleteOptionToString<T> displayStringForOption;

  final AutocompleteOnSelected<T> onSelected;

  final Iterable<T> options;

  final double maxHeight;

  // final OptionWidgetBuilder<T>? cellBuilder;
  final IndexedWidgetBuilder? itemBuilder;

  @override
  State<NAutocompleteOptionsView<T>> createState() => _NAutocompleteOptionsViewState<T>();
}

class _NAutocompleteOptionsViewState<T extends Object> extends State<NAutocompleteOptionsView<T>> {
  final scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TextFieldTapRegion：点击候选项时不让 TextField 失焦，否则 overlay 会先被拆掉，onTap 来不及触发。
    return TextFieldTapRegion(
      child: Align(
        alignment: Alignment.topLeft,
        child: Material(
          elevation: 4.0,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: widget.maxHeight),
            child: Scrollbar(
              controller: scrollController,
              child: ListView.builder(
                controller: scrollController,
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: widget.options.length,
                itemBuilder: (context, index) {
                  final option = widget.options.elementAt(index);
                  return InkWell(
                    onTap: () => widget.onSelected(option),
                    child: widget.itemBuilder?.call(context, index) ??
                        Builder(builder: (context) {
                          final highlight = AutocompleteHighlightedOption.of(context) == index;
                          if (highlight) {
                            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                              Scrollable.ensureVisible(context, alignment: 0.5);
                            });
                          }
                          return Container(
                            color: highlight ? Theme.of(context).focusColor : null,
                            padding: const EdgeInsets.all(16.0),
                            child: Text(widget.displayStringForOption(option)),
                          );
                        }),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
