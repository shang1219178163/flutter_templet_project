import 'package:flutter/cupertino.dart';

// typedef UpdateNotifyBuilder<T> = bool Function(GenericStateWidget oldWidget, T data);

/// InheritedWidget状态管理实现
class GenericStateWidget<T extends ChangeNotifier> extends InheritedWidget {

  GenericStateWidget({
    Key? key,
    required Widget child,
    required this.data,
    required this.updateNotifyBuilder,
    // required bool Function(GenericStateWidget oldWidget, T data) updateNotify,
  }) : super(key: key, child: child);

  final T data;

  // final UpdateNotifyBuilder updateNotifyBuilder;
  final bool Function(GenericStateWidget oldWidget, T data) updateNotifyBuilder;

  @override
  bool updateShouldNotify(GenericStateWidget oldWidget) {
    return this.updateNotifyBuilder(oldWidget, this.data);
  }

  static GenericStateWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<GenericStateWidget>();
  }

}