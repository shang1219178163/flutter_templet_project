import 'package:flutter/material.dart';
import 'package:flutter_templet_project/mixin/safe_set_state_mixin.dart';
import 'package:flutter_templet_project/model/footbal_category_item.dart';
import 'package:flutter_templet_project/pages/demo/ball/BallCategoryContentView.dart';
import 'package:flutter_templet_project/pages/demo/ball/BallCategoryProvider.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';
import 'package:flutter_templet_project/util/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class BallTeamView extends StatefulWidget {
  const BallTeamView({super.key});

  @override
  State<BallTeamView> createState() => _BallTeamViewState();
}

class _BallTeamViewState extends State<BallTeamView> with TickerProviderStateMixin, SafeSetStateMixin {
  TabController? _tabController;
  int _selectedLeftNavIndex = 0;

  late ThemeProvider themeProvider = context.watch<ThemeProvider>();
  late BallCategoryProvider provider = context.read<BallCategoryProvider>();

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<void> initData() async {
    await provider.fetchData(sportType: "football");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      themeProvider.toggleTheme(ThemeMode.light);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (provider.categories.isNotEmpty && _tabController == null) {
      _initTabController(provider.categories.length);
    }
  }

  void _initTabController(int length) {
    _tabController?.dispose();
    _tabController = null;
    _tabController = TabController(length: length, vsync: this);
    _tabController?.addListener(() {
      if (_tabController!.indexIsChanging) {
        return;
      }
      _selectedLeftNavIndex = 0;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BallCategoryProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return Scaffold(
            backgroundColor: themeProvider.color242434OrWhite,
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        if (provider.categories.isEmpty) {
          return Scaffold(
            backgroundColor: themeProvider.color242434OrWhite,
            body: Center(child: Text("没有数据", style: TextStyle(color: themeProvider.titleColor))),
          );
        }
        // 确保 TabController 已被正确初始化
        if (_tabController == null || _tabController!.length != provider.categories.length) {
          _initTabController(provider.categories.length);
        }
        final int currentIndex = _tabController!.index;
        return Column(
          children: [
            Material(
              color: themeProvider.color242434OrWhite,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Center(
                    child: Container(
                      width: 36,
                      height: 3,
                      decoration: BoxDecoration(
                        color: themeProvider.lineColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Container(
                      padding: const EdgeInsets.only(left: 16),
                      child: TabBar(
                        controller: _tabController,
                        isScrollable: true,
                        labelPadding: const EdgeInsets.only(left: 0, right: 8),
                        dividerColor: Colors.transparent,
                        indicatorColor: Colors.transparent,
                        indicator: const BoxDecoration(),
                        labelColor: AppColor.cancelColor,
                        unselectedLabelColor: themeProvider.subtitleColor,
                        labelStyle: const TextStyle(fontSize: 13),
                        unselectedLabelStyle: const TextStyle(fontSize: 13),
                        tabs: provider.categories.asMap().entries.map((entry) {
                          final int index = entry.key;
                          final CategoryItem category = entry.value;
                          final bool isSelected = index == currentIndex;
                          return Tab(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
                              decoration: isSelected
                                  ? BoxDecoration(
                                      color: AppColor.cancelColor.withOpacity(0.1),
                                      border: Border.all(color: AppColor.cancelColor.withOpacity(0.5)),
                                      borderRadius: BorderRadius.circular(6))
                                  : BoxDecoration(
                                      border: Border.all(color: themeProvider.borderColor),
                                      borderRadius: BorderRadius.circular(6)),
                              child: Text(
                                category.name,
                              ),
                            ),
                          );
                        }).toList(),
                      )),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: themeProvider.color242434OrWhite,
                child: TabBarView(
                  controller: _tabController,
                  children: provider.categories.map((e) {
                    return BallCategoryContentView(
                      key: ValueKey(e.id),
                      leftNavItems: e.children ?? [],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
