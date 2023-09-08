


import 'package:flutter/cupertino.dart';

typedef SingleTickerStatefulWidgetBuilder<T> = Widget Function(BuildContext context, StateSetter setState, T value);

/// 混入 SingleTickerProviderStateMixin 的 StatefulBuilder
class SingleTickerStatefulBuilder<T> extends StatefulWidget {

  const SingleTickerStatefulBuilder({
    super.key,
    this.initFunc,
    required this.builder,
  });

  final SingleTickerStatefulWidgetBuilder builder;

  final T Function()? initFunc;

  @override
  _SingleTickerStatefulBuilderState createState() => _SingleTickerStatefulBuilderState<T>();
}

class _SingleTickerStatefulBuilderState<T> extends State<SingleTickerStatefulBuilder> with SingleTickerProviderStateMixin {

  late final _val = widget.initFunc?.call();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, setState, _val);
}
