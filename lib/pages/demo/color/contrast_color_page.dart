import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/enum/color/classic_color.dart';
import 'package:flutter_templet_project/mixin/pair_color_mixin.dart';
import 'package:flutter_templet_project/vendor/toast_util.dart';
import 'package:get/get.dart';

/// 经典撞色：顶部 Tab + TabBarView，每页展示一对撞色卡片
class ContrastColorPage extends StatefulWidget {
  const ContrastColorPage({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<ContrastColorPage> createState() => _ContrastColorPageState();
}

class _ContrastColorPageState extends State<ContrastColorPage> with SingleTickerProviderStateMixin {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final items = ContrastColor.values;
  late final TabController tabController;
  late final List<Widget> pages;
  late final List<Tab> tabs;
  late final Widget tabBarView;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: items.length, vsync: this);
    tabs = items.map((e) => Tab(text: e.label)).toList();
    pages = items.map(_buildContrastPage).toList();
    tabBarView = TabBarView(
      controller: tabController,
      children: pages,
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: tabController.animation!,
      // TabBarView 固定复用，避免点击 Tab 时每帧重建子页导致闪烁
      child: tabBarView,
      builder: (context, child) {
        final (bg, fg) = PairColorMixin.lerpColors(ContrastColor.values, tabController.animation!.value);

        return Scaffold(
          backgroundColor: bg,
          appBar: hideApp
              ? null
              : AppBar(
                  backgroundColor: bg,
                  foregroundColor: fg,
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  iconTheme: IconThemeData(color: fg),
                  actionsIconTheme: IconThemeData(color: fg),
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: fg),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  actions: [
                    IconButton(
                      tooltip: '下一个',
                      icon: Icon(Icons.arrow_forward, color: fg),
                      onPressed: () {
                        final next = (tabController.index + 1) % tabController.length;
                        tabController.animateTo(next);
                      },
                    ),
                  ],
                  title: Text(
                    widget.arguments?['title'] as String? ?? '世界上最经典的撞色',
                    style: TextStyle(color: fg, fontWeight: FontWeight.w600),
                  ),
                  bottom: TabBar(
                    controller: tabController,
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    labelColor: fg,
                    unselectedLabelColor: fg.withValues(alpha: 0.55),
                    indicatorColor: fg,
                    dividerColor: fg.withValues(alpha: 0.2),
                    tabs: tabs,
                  ),
                ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 24, 28, 0),
                child: Text(
                  '世界上最经典的撞色',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: fg,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              Expanded(child: child!),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContrastPage(ContrastColor item) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 28, 28, 32),
        child: Center(
          child: AspectRatio(
            aspectRatio: 0.72,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.55),
                    blurRadius: 28,
                    spreadRadius: 2,
                    offset: const Offset(0, 14),
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.28),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: Column(
                  children: [
                    Expanded(
                      child: _ContrastHalf(
                        bg: item.a.color,
                        fg: item.b.color,
                        styleLabel: '(${item.label})',
                        name: item.a.label,
                        detail: item.a.color.detailLine,
                        onTap: () => copy(item.a.color.detailLine),
                      ),
                    ),
                    Expanded(
                      child: _ContrastHalf(
                        bg: item.b.color,
                        fg: item.a.color,
                        name: item.b.label.endsWith('色') ? item.b.label : '${item.b.label}色',
                        detail: item.b.color.detailLine,
                        onTap: () => copy(item.b.color.detailLine),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> copy(String val) async {
    await Clipboard.setData(ClipboardData(text: val));
    ToastUtil.show('已复制 $val');
  }
}

class _ContrastHalf extends StatelessWidget {
  const _ContrastHalf({
    required this.bg,
    required this.fg,
    required this.name,
    required this.detail,
    required this.onTap,
    this.styleLabel,
  });

  final Color bg;
  final Color fg;
  final String? styleLabel;
  final String name;
  final String detail;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ColoredBox(
        color: bg,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (styleLabel != null) ...[
                  Text(
                    styleLabel!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: fg,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: fg,
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  detail,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: fg,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
