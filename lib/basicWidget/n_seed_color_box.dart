import 'package:flutter/material.dart';

class NSeedColorBox extends StatefulWidget {
  const NSeedColorBox({
    super.key,
    required this.items,
    this.index = 0,
    this.brightness = Brightness.light,
    this.onColorChanged,
    this.onBrightnessChanged,
  });

  final List<Color> items;
  final int index;
  final Brightness brightness;

  final ValueChanged<Color>? onColorChanged;
  final ValueChanged<Brightness>? onBrightnessChanged;

  @override
  State<NSeedColorBox> createState() => _NSeedColorBoxState();
}

class _NSeedColorBoxState extends State<NSeedColorBox> {
  late List<Color> items = widget.items;
  late int index = widget.index;
  late Color seedColor = widget.items[index];
  late Brightness brightness = widget.brightness;

  @override
  void didUpdateWidget(covariant NSeedColorBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.index != widget.index) {
      index = widget.index;
      seedColor = widget.items[index];
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '选择种子颜色',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                if (widget.onBrightnessChanged != null)
                  IconButton(
                    icon: Icon(brightness == Brightness.light ? Icons.dark_mode : Icons.light_mode),
                    onPressed: () {
                      brightness = brightness == Brightness.light ? Brightness.dark : Brightness.light;
                      setState(() {});
                      widget.onBrightnessChanged?.call(brightness);
                    },
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: items.map((color) {
                final i = items.indexOf(color);
                final isSelected = i == index;
                final borderColor = isSelected ? color : color.withValues(alpha: 0);
                return GestureDetector(
                  onTap: () {
                    index == i;
                    widget.onColorChanged?.call(color);
                    setState(() {});
                  },
                  child: Container(
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: borderColor, width: 2),
                    ),
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            Text(
              '当前种子颜色: ${seedColor.toString()}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '当前模式: ${brightness == Brightness.light ? '浅色模式' : '深色模式'}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

mixin SeedColorMixin<T extends StatefulWidget> on State<T> {
  /// 选择主题
  void showSeedColorPicker({bool dismiss = true}) {
    final colors = [
      ...Colors.primaries,
      ...Colors.accents,
    ];
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      constraints: BoxConstraints(
        minHeight: 200,
        maxHeight: 500,
      ),
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                NSeedColorBox(
                  items: [
                    ...Colors.primaries,
                    ...Colors.accents,
                  ],
                  onColorChanged: (v) {
                    setState(() {});
                    if (dismiss) {
                      Navigator.of(context).pop();
                    }
                    debugPrint("onColorChanged $v");
                  },
                  onBrightnessChanged: (v) {
                    setState(() {});
                    if (dismiss) {
                      Navigator.of(context).pop();
                    }
                    debugPrint("onBrightnessChanged $v");
                  },
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
