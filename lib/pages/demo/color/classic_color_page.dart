import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/enum/color/classic_color.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/vendor/toast_util.dart';
import 'package:get/get.dart';

/// 经典色板：Wrap 每行 8 个，点击后在顶部展示颜色详情
class ClassicColorPage extends StatefulWidget {
  const ClassicColorPage({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<ClassicColorPage> createState() => _ClassicColorPageState();
}

class _ClassicColorPageState extends State<ClassicColorPage> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final scrollController = ScrollController();
  final items = ClassicColor.values;

  ClassicColor selected = ClassicColor.values.first;

  static const int crossAxisCount = 6;
  static const double spacing = 8;
  static const double runSpacing = 8;
  static const double radius = 999;

  late final themeData = Theme.of(context);
  late final primary = themeData.colorScheme.primary;
  late final isDark = themeData.brightness == Brightness.dark;

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hideApp
          ? null
          : AppBar(
              backgroundColor: selected.color,
              title: Text('经典色'),
            ),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(child: buildBody()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final fg = selected.color.textColor();

    final colorHex = selected.color.hex;

    return Material(
      color: selected.color,
      child: InkWell(
        onTap: () => copy(selected.detailLine),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selected.label,
                      style: TextStyle(
                        color: fg,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      selected.detailLine,
                      style: TextStyle(
                        color: fg.withValues(alpha: 0.9),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.copy, size: 18, color: fg.withValues(alpha: 0.8)),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBody() {
    return Scrollbar(
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        padding: const EdgeInsets.all(12),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final itemSize =
                ((constraints.maxWidth - spacing * (crossAxisCount - 1)) / crossAxisCount).truncateToDouble();

            return Wrap(
              spacing: spacing,
              runSpacing: runSpacing,
              children: items.map((e) {
                final isSelected = selected == e;
                final bgColor = isSelected ? themeData.colorScheme.onPrimary : e.color;
                return GestureDetector(
                  onTap: () {
                    selected = e;
                    setState(() {});
                  },
                  child: CircleAvatar(
                    backgroundColor: e.color,
                    radius: itemSize * 0.5 + 2,
                    child: CircleAvatar(
                      backgroundColor: bgColor,
                      radius: itemSize * 0.5,
                      child: CircleAvatar(
                        backgroundColor: e.color,
                        radius: itemSize * 0.5 - 4,
                        child: Icon(Icons.check, color: bgColor),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }

  Future<void> copy(String val) async {
    await Clipboard.setData(ClipboardData(text: val));
    ToastUtil.show('已复制 $val');
  }
}
