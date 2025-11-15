import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/scroll/EndBounceScrollPhysics.dart';
import 'package:flutter_templet_project/model/footbal_category_item.dart';
import 'package:flutter_templet_project/pages/demo/ball/BallCategoryProvider.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';
import 'package:flutter_templet_project/util/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

class BallCategoryContentView extends StatefulWidget {
  final List<CategoryItem> leftNavItems;

  const BallCategoryContentView({super.key, required this.leftNavItems});

  @override
  State<BallCategoryContentView> createState() => _BallCategoryContentViewState();
}

class _BallCategoryContentViewState extends State<BallCategoryContentView> {
  int _selectedLeftNavIndex = 0;
  bool _isScrollingProgrammatically = false;

  // scrollable_positioned_list 的控制器
  final _itemScrollController = ItemScrollController();
  final _itemPositionsListener = ItemPositionsListener.create();

  // 左侧ListView的滚动控制器
  final _leftNavScrollController = ScrollController();

  ThemeProvider get themeProvider => context.read<ThemeProvider>();

  @override
  void initState() {
    super.initState();
    // 监听右侧列表的滚动
    _itemPositionsListener.itemPositions.addListener(_onRightListScroll);
  }

  @override
  void dispose() {
    _itemPositionsListener.itemPositions.removeListener(_onRightListScroll);
    _leftNavScrollController.dispose();
    super.dispose();
  }

  // 当右侧列表滚动时触发
  void _onRightListScroll() {
    // 如果是程序触发的滚动，则忽略，防止循环触发
    if (_isScrollingProgrammatically) {
      return;
    }

    // 获取当前可见的第一个 item 的索引
    final firstVisibleIndex = _itemPositionsListener.itemPositions.value
        .where((position) => position.itemLeadingEdge >= 0)
        .map((position) => position.index)
        .firstOrNull;

    if (firstVisibleIndex != null && firstVisibleIndex != _selectedLeftNavIndex) {
      _selectedLeftNavIndex = firstVisibleIndex;
      setState(() {});

      // 自动滚动左侧导航到选中项
      _scrollLeftNavToSelected();
    }
  }

  //初始：选中项在上方，未越过中线 ➜ 不滚动
  // 当选中项 刚好或刚好越过中线时 ➜ 滚动使它居中
  // 如果已经居中，再次选中其他项 ➜ 正常触发滚动
  // 只有刚好越界，才触发一次居中滚动（不是每次都滚）
  int _lastCenteredIndex = -1;

  void _scrollLeftNavToSelected() {
    LinkedScrollUtils.scrollToCenterIfNeeded(
      controller: _leftNavScrollController,
      index: _selectedLeftNavIndex,
      itemHeight: 44.0,
      lastCenteredIndex: _lastCenteredIndex,
      onCentered: (newIndex) {
        _lastCenteredIndex = newIndex;
      },
    );
  }

  // 点击左侧导航时，滚动右侧列表到指定位置
  Future<void> _scrollToIndex(int index) async {
    // 标记为程序滚动
    _isScrollingProgrammatically = true;
    _selectedLeftNavIndex = index;
    setState(() {});

    // 执行滚动动画
    await _itemScrollController.scrollTo(
      index: index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    // 动画结束后，延时一小段时间再解除标记，确保 onScroll 监听不会误判
    await Future.delayed(const Duration(milliseconds: 350));
    _isScrollingProgrammatically = false;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.leftNavItems.isEmpty) {
      return Center(
        child: Text("该分类下无数据", style: TextStyle(color: themeProvider.titleColor)),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 左侧导航栏
        buildLeftNav(widget.leftNavItems),
        // 右侧内容网格（现在是可滚动的列表）
        buildRightContent(widget.leftNavItems),
      ],
    );
  }

  // 构建左侧导航栏
  Widget buildLeftNav(List<CategoryItem> leftNavItems) {
    return Container(
      width: 88,
      color: themeProvider.color181829OrF6F6F6,
      child: Consumer<BallCategoryProvider>(builder: (context, provider, child) {
        return ListView.builder(
          controller: _leftNavScrollController,
          padding: const EdgeInsets.only(bottom: 120),
          physics: !provider.isExpanded ? const NeverScrollableScrollPhysics() : const ClampingScrollPhysics(),
          itemCount: leftNavItems.length,
          itemBuilder: (context, index) {
            final item = leftNavItems[index];
            final isSelected = index == _selectedLeftNavIndex;

            return InkWell(
              onTap: () {
                _scrollToIndex(index);
              },
              child: Stack(
                children: [
                  Visibility(
                    visible: _selectedLeftNavIndex != 0
                        ? index == _selectedLeftNavIndex - 1 || index == _selectedLeftNavIndex + 1
                        : index == _selectedLeftNavIndex + 1,
                    child: Container(height: 44, color: themeProvider.color242434OrWhite),
                  ),
                  Container(
                    height: 44,
                    // padding: const EdgeInsets.symmetric(vertical: 14.0),
                    decoration: BoxDecoration(
                        color: isSelected ? themeProvider.color242434OrWhite : themeProvider.color181829OrF6F6F6,
                        borderRadius: !isSelected
                            ? _selectedLeftNavIndex != 0
                                ? BorderRadius.only(
                                    topRight: Radius.circular(index == _selectedLeftNavIndex - 1 ? 0 : 8),
                                    bottomRight: Radius.circular((index == _selectedLeftNavIndex + 1) ? 0 : 8))
                                : const BorderRadius.only(topRight: Radius.circular(8))
                            : null),
                    child: Center(
                      child: Text(
                        item.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: isSelected ? AppColor.cancelColor : themeProvider.subtitleColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }

  // 构建右侧内容
  Widget buildRightContent(List<CategoryItem> leftNavItems) {
    return Expanded(
      child: Container(
        color: themeProvider.color242434OrWhite,
        child: Consumer<BallCategoryProvider>(builder: (context, provider, child) {
          return ScrollablePositionedList.builder(
            physics: !provider.isExpanded ? const NeverScrollableScrollPhysics() : const EndBounceScrollPhysics(),
            itemCount: leftNavItems.length,
            itemScrollController: _itemScrollController,
            itemPositionsListener: _itemPositionsListener,
            padding: const EdgeInsets.only(bottom: 20),
            itemBuilder: (context, index) {
              // 每个 item 是一个分类区块
              final categorySection = leftNavItems[index];
              final gridItems = categorySection.children ?? [];

              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 分类标题
                    Container(
                      padding: const EdgeInsets.only(bottom: 16, top: 6),
                      child: Text(
                        categorySection.name,
                        style: TextStyle(
                          color: themeProvider.titleColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    // const SizedBox(height: 12),
                    // 内容网格
                    GridView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 1,
                        mainAxisSpacing: 1,
                        childAspectRatio: 0.98,
                      ),
                      itemCount: gridItems.length,
                      itemBuilder: (context, gridIndex) {
                        final item = gridItems[gridIndex];
                        return InkWell(
                          onTap: () {
                            DLog.d(item.name);
                          },
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              final gridItemWidth = constraints.maxWidth;
                              // final imageSize = (gridItemWidth * 0.5).clamp(24.0, 36.0);
                              // double fontSize = gridItemWidth < 70 ? 10 : 12;
                              var spacingHeight = gridItemWidth < 70 ? 2.5 : 5.0;
                              var imageSize = 36.0;
                              var fontSize = 12.0;

                              return Container(
                                // color: Colors.green,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: item.logo ?? "",
                                      width: imageSize,
                                      height: imageSize,
                                      errorWidget: (_, __, ___) => Icon(Icons.photo),
                                    ),
                                    SizedBox(height: spacingHeight),
                                    Flexible(
                                      child: Text(
                                        item.name,
                                        style: TextStyle(color: themeProvider.titleColor, fontSize: fontSize),
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
