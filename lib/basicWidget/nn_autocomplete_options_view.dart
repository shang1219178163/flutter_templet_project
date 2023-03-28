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
class NNAutocompleteOptionsView<T extends Object> extends StatelessWidget {
  const NNAutocompleteOptionsView({
    Key? key,
    required this.displayStringForOption,
    required this.onSelected,
    required this.options,
    required this.maxOptionsHeight,
    this.cellBuilder
  }) : super(key: key);

  final AutocompleteOptionToString<T> displayStringForOption;

  final AutocompleteOnSelected<T> onSelected;

  final Iterable<T> options;

  final double maxOptionsHeight;

  // final OptionWidgetBuilder<T>? cellBuilder;
  final IndexedWidgetBuilder? cellBuilder;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Material(
        elevation: 4.0,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxOptionsHeight),
          child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: options.length,
            itemBuilder: (BuildContext context, int index) {
              final T option = options.elementAt(index);
              return cellBuilder?.call(context, index) ?? InkWell(
                onTap: () {
                  onSelected(option);
                },
                child: Builder(
                  builder: (BuildContext context) {
                    final bool highlight = AutocompleteHighlightedOption.of(context) == index;
                    if (highlight) {
                      SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) {
                        Scrollable.ensureVisible(context, alignment: 0.5);
                      });
                    }
                    return Container(
                      color: highlight ? Theme.of(context).focusColor : null,
                      padding: const EdgeInsets.all(16.0),
                      child: Text(displayStringForOption(option)),
                    );
                  }
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}


