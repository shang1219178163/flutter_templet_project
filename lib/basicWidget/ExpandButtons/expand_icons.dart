import 'package:flutter/material.dart';

// https://stackoverflow.com/questions/46480221/flutter-floating-action-button-with-speed-dail
class ExpandIcons extends StatefulWidget {
  ExpandIcons({super.key, required this.items, required this.onItem});
  final List<IconData> items;
  final ValueChanged<int> onItem;

  @override
  State createState() => ExpandIconsState();
}

class ExpandIconsState extends State<ExpandIcons>
    with TickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 250),
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.items.length, (int index) {
        return _buildChild(index);
      }).toList()
        ..add(
          _buildFab(),
        ),
    );
  }

  Widget _buildChild(int index) {
    var backgroundColor = Theme.of(context).cardColor;
    var foregroundColor = Theme.of(context).primaryColor;
    return Container(
      height: 70.0,
      width: 56.0,
      alignment: FractionalOffset.topCenter,
      child: ScaleTransition(
        scale: CurvedAnimation(
          parent: _controller,
          curve: Interval(0.0, 1.0 - index / widget.items.length / 2.0,
              curve: Curves.easeOut),
        ),
        child: FloatingActionButton(
          backgroundColor: backgroundColor,
          mini: true,
          child: Icon(widget.items[index], color: foregroundColor),
          onPressed: () => _onTapped(index),
        ),
      ),
    );
  }

  Widget _buildFab() {
    return FloatingActionButton(
      onPressed: () {
        if (_controller.isDismissed) {
          _controller.forward();
        } else {
          _controller.reverse();
        }
      },
      tooltip: 'Increment',
      elevation: 2.0,
      child: Icon(Icons.add),
    );
  }

  void _onTapped(int index) {
    _controller.reverse();
    widget.onItem(index);
  }
}
