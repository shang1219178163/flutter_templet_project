import 'package:flutter/material.dart';

mixin RebuildMixin<T extends StatefulWidget> on State<T> {
  int _rebuildCount = 0;

  @override
  Widget build(BuildContext context) {
    _rebuildCount++;
    debugPrint('${widget.runtimeType} rebuilt $_rebuildCount times');
    return buildWithCount(context, _rebuildCount);
  }

  Widget buildWithCount(BuildContext context, int count);
}
