import 'package:flutter/material.dart';

/// Builds the display for one segment item.
typedef NSegmentedButtonItemBuilder<T> = Widget Function(
  BuildContext context,
  T item,
  bool selected,
);

/// Sliding segmented control with content-adaptive item widths.
class NSegmentedButton<T> extends StatefulWidget {
  const NSegmentedButton({
    super.key,
    required this.items,
    required this.itemBuilder,
    required this.index,
    required this.onChanged,
    this.height = 30,
    this.inset = 3,
    this.itemPadding = const EdgeInsets.symmetric(horizontal: 12),
  });

  /// Segment values (width follows each built child).
  final List<T> items;

  /// Builds the visible content for each [items] item.
  final NSegmentedButtonItemBuilder<T> itemBuilder;

  /// Currently selected index.
  final int index;

  final ValueChanged<int> onChanged;

  final double height;
  final double inset;
  final EdgeInsetsGeometry itemPadding;

  @override
  State<NSegmentedButton<T>> createState() => _NSegmentedButtonState<T>();
}

class _NSegmentedButtonState<T> extends State<NSegmentedButton<T>> {
  late List<GlobalKey> _itemKeys = List.generate(widget.items.length, (_) => GlobalKey());
  List<double> _widths = const [];

  @override
  void didUpdateWidget(covariant NSegmentedButton<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items.length != widget.items.length) {
      _itemKeys = List.generate(widget.items.length, (_) => GlobalKey());
      _widths = const [];
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
  }

  void _measure() {
    if (!mounted) {
      return;
    }
    final next = <double>[];
    for (final key in _itemKeys) {
      final width = key.currentContext?.size?.width ?? 0;
      next.add(width);
    }
    if (next.length != _widths.length || !_listEqualsApprox(next, _widths)) {
      setState(() => _widths = next);
    }
  }

  bool _listEqualsApprox(List<double> a, List<double> b) {
    if (a.length != b.length) {
      return false;
    }
    for (var i = 0; i < a.length; i++) {
      if ((a[i] - b[i]).abs() > 0.5) {
        return false;
      }
    }
    return true;
  }

  double get _thumbLeft {
    if (_widths.isEmpty || widget.index <= 0) {
      return 0;
    }
    return _widths.take(widget.index).fold<double>(0, (sum, w) => sum + w);
  }

  double get _thumbWidth {
    if (_widths.isEmpty || widget.index < 0 || widget.index >= _widths.length) {
      return 0;
    }
    return _widths[widget.index];
  }

  bool get _ready => _widths.length == widget.items.length && _widths.every((w) => w > 0);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: scheme.surfaceContainerHighest.withValues(alpha: 0.75),
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: EdgeInsets.all(widget.inset),
        child: SizedBox(
          height: widget.height,
          child: Stack(
            children: [
              if (_ready)
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  left: _thumbLeft,
                  top: 0,
                  width: _thumbWidth,
                  height: widget.height,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: scheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: scheme.shadow.withValues(alpha: 0.10),
                          blurRadius: 6,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < widget.items.length; i++)
                    KeyedSubtree(
                      key: _itemKeys[i],
                      child: _NSegmentedButtonItem(
                        height: widget.height,
                        padding: widget.itemPadding,
                        selected: widget.index == i,
                        onTap: () => widget.onChanged(i),
                        child: widget.itemBuilder(
                          context,
                          widget.items[i],
                          widget.index == i,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NSegmentedButtonItem extends StatelessWidget {
  const _NSegmentedButtonItem({
    required this.height,
    required this.padding,
    required this.selected,
    required this.onTap,
    required this.child,
  });

  final double height;
  final EdgeInsetsGeometry padding;
  final bool selected;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        height: height,
        child: Padding(
          padding: padding,
          child: Center(
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              style: TextStyle(
                fontSize: 12,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? scheme.primary : scheme.onSurfaceVariant,
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
