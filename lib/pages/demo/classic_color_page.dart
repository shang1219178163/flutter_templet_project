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
              title: Text(widget.arguments?['title'] as String? ?? '经典色'),
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
    final item = selected;
    final fg = item.color.textColor();
    return Material(
      color: item.color,
      child: InkWell(
        onTap: () => copy(item.detailLine),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: item.color,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: fg.withValues(alpha: 0.35)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.label,
                      style: TextStyle(
                        color: fg,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.detailLine,
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
                return GestureDetector(
                  onTap: () {
                    selected = e;
                    setState(() {});
                  },
                  child: Container(
                    width: itemSize,
                    height: itemSize,
                    decoration: BoxDecoration(
                      color: e.color,
                      borderRadius: BorderRadius.circular(radius),
                      border: Border.all(
                        color: isSelected ? Colors.white : Colors.black12,
                        width: isSelected ? 2 : 1,
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
