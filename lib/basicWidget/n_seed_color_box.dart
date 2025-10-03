import 'package:flutter/material.dart';

class NSeedColorBox extends StatefulWidget {
  const NSeedColorBox({
    super.key,
    required this.colorOptions,
    this.index,
    this.brightness = Brightness.light,
    this.onColorChanged,
    this.onBrightnessChanged,
  });

  final List<Color> colorOptions;
  final int? index;
  final Brightness brightness;

  final ValueChanged<Color>? onColorChanged;
  final ValueChanged<Brightness>? onBrightnessChanged;

  @override
  State<NSeedColorBox> createState() => _NSeedColorBoxState();
}

class _NSeedColorBoxState extends State<NSeedColorBox> {
  late List<Color> colorOptions = widget.colorOptions;
  late int index = widget.index ?? 0;
  late Color seedColor = widget.colorOptions[index];
  late Brightness brightness = widget.brightness;

  @override
  void didUpdateWidget(covariant NSeedColorBox oldWidget) {
    super.didUpdateWidget(oldWidget);
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
              children: colorOptions.map((color) {
                return GestureDetector(
                  onTap: () {
                    seedColor = color;
                    setState(() {});
                    widget.onColorChanged?.call(color);
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(8),
                      border: seedColor.value == color.value
                          ? Border.all(
                              color: Theme.of(context).colorScheme.primary,
                              width: 3,
                            )
                          : null,
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
                  colorOptions: [
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
