import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_fe_app/provider/theme_provider.dart';
import 'package:social_fe_app/value/app_colors.dart';

class SessionSelectWidget extends StatefulWidget {
  final Function(String) callback;

  const SessionSelectWidget({super.key, required this.callback});

  @override
  State<SessionSelectWidget> createState() => _SessionSelectWidgetState();
}

class _SessionSelectWidgetState extends State<SessionSelectWidget> with TickerProviderStateMixin {
  List titles = ['6', '10', '20'];
  late TabController controller;
  int index = 0;

  @override
  void initState() {
    controller = TabController(length: titles.length, vsync: this);
    controller.addListener(() {
      if (!controller.indexIsChanging) {
        index = controller.index;
        widget.callback(titles[index]);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    late final themeProvider = context.read<ThemeProvider>();

    return Container(
      height: 25,
      width: 140,
      decoration: BoxDecoration(
        color: themeProvider.isDark ? Colors.white.withOpacity(0.05) : AppColors.bgColorF6F6F6,
        border: Border.all(
          color: themeProvider.isDark ? Colors.white.withOpacity(0.1) : AppColors.bgColorF6F6F6,
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
          controller: controller,
          dividerHeight: 0,
          labelStyle: const TextStyle(fontSize: 12, color: Colors.white),
          unselectedLabelStyle: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.8)),
          tabAlignment: TabAlignment.fill,
          indicatorSize: TabBarIndicatorSize.tab,
          labelPadding: const EdgeInsets.symmetric(horizontal: 0),
          indicator: BoxDecoration(
            color: AppColors.colorE44554.withOpacity(0.1),
            border: Border.all(color: AppColors.colorE44554, width: 0.5),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          tabs: List.generate(titles.length, (index) {
            bool selected = index == controller.index;
            return Center(
              child: Text(
                titles[index] + (selected ? '场' : ''),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  color: selected ? AppColors.colorE44554 : themeProvider.titleColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          })),
    );
  }
}
