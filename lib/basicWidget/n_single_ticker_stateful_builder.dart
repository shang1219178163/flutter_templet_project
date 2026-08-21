import 'package:flutter/cupertino.dart';

typedef NSingleTickerStatefulWidgetBuilder<T> = Widget Function(
    BuildContext context, StateSetter setState, T value);

/// 混入 SingleTickerProviderStateMixin 的 StatefulBuilder
class NSingleTickerStatefulBuilder<T> extends StatefulWidget {
  const NSingleTickerStatefulBuilder({
    super.key,
    this.initFunc,
    required this.builder,
  });

  final NSingleTickerStatefulWidgetBuilder builder;

  final T Function()? initFunc;

  @override
  _NSingleTickerStatefulBuilderState createState() =>
      _NSingleTickerStatefulBuilderState<T>();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<NSingleTickerStatefulWidgetBuilder>.has('builder', builder));
    properties.add(ObjectFlagProperty<T Function()?>.has('initFunc', initFunc));
  }
}

class _NSingleTickerStatefulBuilderState<T>
    extends State<NSingleTickerStatefulBuilder>
    with SingleTickerProviderStateMixin {
  late final _val = widget.initFunc?.call();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, setState, _val);
}
