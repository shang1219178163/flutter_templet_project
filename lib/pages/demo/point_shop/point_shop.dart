import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/basicWidget/n_back_button.dart';
import 'package:flutter_templet_project/basicWidget/n_logo_card.dart';
import 'package:flutter_templet_project/basicWidget/n_placeholder.dart';
import 'package:flutter_templet_project/basicWidget/n_tab_bar_fixed_width_indicator.dart';
import 'package:flutter_templet_project/basicWidget/n_tab_bar_indicator_fixed.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/generated/assets.dart';
import 'package:flutter_templet_project/pages/demo/point_shop/enum/goods_category_enum.dart';
import 'package:flutter_templet_project/pages/demo/point_shop/model/PointGoodsRootModel.dart';
import 'package:flutter_templet_project/pages/demo/point_shop/model/ShopGoodsCategoryModel.dart';
import 'package:flutter_templet_project/pages/demo/point_shop/widget/goods_chat_bubble_item.dart';
import 'package:flutter_templet_project/pages/demo/point_shop/widget/goods_detail_popup.dart';
import 'package:flutter_templet_project/pages/demo/point_shop/widget/goods_enter_effect_item.dart';
import 'package:flutter_templet_project/pages/demo/point_shop/widget/goods_gift_item.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:flutter_templet_project/util/scrollable_positioned_list_ext/item_positions_listener_ext.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';
import 'package:flutter_templet_project/util/theme/theme_provider.dart';
import 'package:flutter_templet_project/vendor/toast_util.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

/// 熊猫币商城
class PointShop extends StatefulWidget {
  const PointShop({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<PointShop> createState() => _PointShopState();
}

class _PointShopState extends State<PointShop> with TickerProviderStateMixin {
  final scrollController = ScrollController();

  final itemScrollController = ItemScrollController();
  final itemPositionsListener = ItemPositionsListener.create();

  late final refreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  List<ShopGoodsCategoryModel> categorys = [];

  double tabHeight = 48;

  TabController? tabController;

  late final mediaData = MediaQuery.of(context);

  late final themeProvider = context.read<ThemeProvider>();

  @override
  void dispose() {
    tabController?.removeListener(tabIndexLtr);
    tabController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    initData();
  }

  initData() async {
    itemPositionsListener.itemPositions.addListener(() {
      final targetIndex = itemPositionsListener.currentIndex;
      // print('targetIndex: $targetIndex');
      tabController?.animateTo(targetIndex);
    });

    onRefresh().then((_) {
      setState(() {});
    });
  }

  updateTabController() {
    if (categorys.isEmpty) {
      return;
    }
    // tabController?.dispose();
    tabController = TabController(length: categorys.length, vsync: this);
    // tabController!.removeListener(tabIndexLtr);
    // tabController!.addListener(tabIndexLtr);
  }

  tabIndexLtr() {
    if (tabController == null) {
      return;
    }
    itemScrollController.scrollTo(
      index: tabController!.index,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: themeProvider.color242434OrWhite,
        image: DecorationImage(
          image: AssetImage(Assets.shopBgPandaCoinShop),
          fit: BoxFit.fitWidth,
          alignment: Alignment.topCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
          leading: const NBackButton(color: Colors.white),
          leadingWidth: 48,
          title: const Text("熊猫币商城"),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(tabHeight),
            child: buildTab(),
          ),
        ),
        body: buildBody(),
      ),
    );
  }

  Widget buildTab() {
    if (tabController == null) {
      return buildPlacholder(height: tabHeight);
    }

    return Container(
      height: tabHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        color: themeProvider.color242434OrWhite,
        // border: Border.all(color: Colors.blue),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
      ),
      child: TabBar(
        controller: tabController!,
        labelColor: Colors.pink,
        unselectedLabelColor: AppColor.fontColor737373,
        tabs: categorys.map((e) => Tab(text: e.categoryName ?? "-")).toList(),
        // labelPadding: const EdgeInsets.symmetric(horizontal: 2),
        // indicatorPadding: const EdgeInsets.only(bottom: 8),
        indicator: NTabBarIndicatorFixed(
          color: Colors.pink,
          width: 20,
          height: 3,
          margin: EdgeInsets.only(bottom: 6),
        ),
        onTap: (index) {
          // DLog.d(index);
          tabIndexLtr();
        },
      ),
    );
  }

  Widget buildPlacholder({double? height, Widget? child}) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: themeProvider.color242434OrWhite,
        // border: Border.all(color: Colors.blue),
        // borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
      ),
      child: child,
    );
  }

  Widget buildBody() {
    if (tabController == null) {
      return buildPlacholder(child: const NPlaceholder());
    }

    return Container(
      decoration: BoxDecoration(
        color: themeProvider.color242434OrWhite,
        // border: Border.all(color: Colors.blue),
        // borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
      ),
      child: EasyRefresh(
        controller: refreshController,
        onRefresh: onRefresh,
        child: ScrollablePositionedList.separated(
          itemCount: categorys.length,
          itemScrollController: itemScrollController,
          itemPositionsListener: itemPositionsListener,
          itemBuilder: (context, index) {
            final v = categorys[index];
            final i = categorys.indexOf(v);
            final e = v.categoryEnum!;
            final typeName = v.categoryName ?? "-";
            final typeColor = themeProvider.isDark ? e.color : e.colorLight;
            final typeLogo = themeProvider.isDark ? e.logo : e.logoLight;
            final items = v.goodsList ?? [];
            final itemHeight = e.itemHeight;
            final rowCount = e.rowCount;

            Widget child = const SizedBox();
            switch (v.categoryEnum) {
              case GoodsCategoryEnum.gift:
                {
                  child = buildGridView(
                    items: items,
                    itemHeight: itemHeight.toDouble(),
                    rowCount: rowCount,
                    onChanged: (i) {
                      DLog.d(items[i].toJson());
                    },
                    itemBuilder: (_, i) {
                      final model = items[i];
                      return buildItem(type: v, model: model);
                    },
                  );
                }
                break;
              case GoodsCategoryEnum.bubble:
                {
                  child = buildListView(
                    scrollDirection: Axis.horizontal,
                    items: items,
                    itemHeight: itemHeight.toDouble(),
                    rowCount: 3.65,
                    onChanged: (i) {
                      DLog.d(items[i].toJson());
                    },
                    itemBuilder: (_, i) {
                      final model = items[i];
                      return buildItem(type: v, model: model);
                    },
                  );
                }
              default:
                child = buildWrap(
                  items: items,
                  itemHeight: itemHeight.toDouble(),
                  rowCount: rowCount,
                  onChanged: (i) {
                    DLog.d(items[i].toJson());
                  },
                  itemBuilder: (_, i) {
                    final model = items[i];
                    return buildItem(type: v, model: model);
                  },
                );
                break;
            }

            return NLogoCard(
              name: typeName,
              color: typeColor,
              logo: typeLogo,
              margin: const EdgeInsets.all(12).copyWith(
                top: 0,
                bottom: v == categorys.last ? 100 : 0,
              ),
              child: child,
            );
          },
          separatorBuilder: (context, index) {
            return const SizedBox(height: 12);
          },
        ),
      ),
    );
  }

  Widget buildGridView<E>({
    required List<E> items,
    int rowCount = 4,
    double? itemHeight,
    required ValueChanged<int> onChanged,
    IndexedWidgetBuilder? itemBuilder,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 8.0;
        final maxWidth = constraints.maxWidth.truncateToDouble();
        final itemWidth = (maxWidth - spacing * (rowCount - 1)) / rowCount;

        return Container(
          width: maxWidth,
          height: maxWidth * 3 / 4,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: themeProvider.color242434OrWhite,
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            removeBottom: true,
            child: GridView.custom(
              physics: const ClampingScrollPhysics(),
              // padding: EdgeInsets.all(15.0),
              scrollDirection: Axis.vertical,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                // crossAxisSpacing: 8,
                // mainAxisSpacing: 8,
              ),
              childrenDelegate: SliverChildBuilderDelegate(
                (context, i) {
                  final btnTitle = "card $i";
                  return GestureDetector(
                    onTap: () => onChanged(i),
                    child: SizedBox(
                      width: itemWidth.truncateToDouble(),
                      height: itemHeight ?? itemWidth,
                      child: itemBuilder?.call(context, i) ?? Text(btnTitle),
                    ),
                  );
                },
                childCount: items.length,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildWrap<E>({
    required List<E> items,
    int rowCount = 4,
    double? itemHeight,
    required ValueChanged<int> onChanged,
    IndexedWidgetBuilder? itemBuilder,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 8.0;
        final itemWidth = (constraints.maxWidth - spacing * (rowCount - 1)) / rowCount;

        return Container(
          decoration: const BoxDecoration(
            // color: themeProvider.color242434OrWhite,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: Wrap(
            spacing: spacing,
            runSpacing: spacing,
            // crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              ...items.map(
                (e) {
                  final i = items.indexOf(e);
                  final btnTitle = "card $i";
                  return GestureDetector(
                    onTap: () => onChanged(i),
                    child: SizedBox(
                      width: itemWidth.truncateToDouble(),
                      height: itemHeight ?? itemWidth,
                      child: itemBuilder?.call(context, i) ?? Text(btnTitle),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildListView<E>({
    Axis scrollDirection = Axis.vertical,
    required List<E> items,
    double rowCount = 4,
    double? itemHeight,
    required ValueChanged<int> onChanged,
    required NullableIndexedWidgetBuilder itemBuilder,
  }) {
    final isVertical = scrollDirection == Axis.vertical;
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 8.0;
        final itemWidth = (constraints.maxWidth - spacing * (rowCount - 1)) / rowCount;
        return Container(
          height: isVertical ? null : itemHeight ?? 80,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: ListView.separated(
            scrollDirection: scrollDirection,
            physics: items.length == rowCount ? const NeverScrollableScrollPhysics() : const ClampingScrollPhysics(),
            itemBuilder: (c, i) {
              return GestureDetector(
                onTap: () => onChanged(i),
                child: SizedBox(
                  width: itemWidth.truncateToDouble(),
                  height: itemHeight ?? itemWidth,
                  child: itemBuilder(c, i),
                ),
              );
            },
            separatorBuilder: (_, i) {
              return SizedBox(
                width: isVertical ? 0 : 8,
                height: isVertical ? 8 : 0,
              );
            },
            itemCount: items.length,
          ),
        );
      },
    );
  }

  Widget buildItem({required ShopGoodsCategoryModel type, required ShopGoodsDetailModel model}) {
    Widget child = const SizedBox();
    switch (type.categoryEnum) {
      case GoodsCategoryEnum.gift:
        {
          child = GoodsGiftItem(
            model: model,
            color: themeProvider.color242434OrWhite,
          );
        }
        break;
      case GoodsCategoryEnum.bubble:
        {
          child = GoodsChatBubbleItem(
            model: model,
            color: themeProvider.color242434OrWhite,
          );
        }
        break;
      case GoodsCategoryEnum.enter_effect:
        {
          child = GoodsEnterEffectItem(
            model: model,
            color: themeProvider.color242434OrWhite,
          );
        }
        break;
      default:
        break;
    }
    return GestureDetector(
      onTap: () {
        // ToastUtil.show("请耐心等待,功能暂未开放");
        if (type.categoryEnum == null) {
          ToastUtil.show("礼物分类 不能为空");
          return;
        }
        // DLog.d(model.toJson().convertByIndent());
        GoodsDetailPopup.show(
          context: context,
          categoryEnum: type.categoryEnum!,
          model: model,
          onEquip: () {
            DLog.d("onEquip");
            //   final needUpdate = [
            //     GoodsCategoryEnum.bubble,
            //     GoodsCategoryEnum.enter_effect,
            //   ].contains(type.categoryEnum);
            //   if (!needUpdate) {
            //     return;
            //   }
            //
            //   final index = categorys.indexOf(type);
            //   final goodsList = categorys[index].goodsList ?? [];
            //   for (var i = 0; i < goodsList.length; i++) {
            //     final e = goodsList[i];
            //     final isCurrent = (e.goodsId == model.goodsId);
            //     if (isCurrent) {
            //       (categorys[index].goodsList ?? [])[i].goodsStatus = GoodsStatusEnum.equipped.name;
            //       (categorys[index].goodsList ?? [])[i].categoryCode = type.categoryCode;
            //     } else {
            //       if (e.goodsStatus == GoodsStatusEnum.equipped.name) {
            //         e.goodsStatus = GoodsStatusEnum.owned.name;
            //       }
            //     }
            //     if (isCurrent) {
            //       UserInfoController.instance.cacheEquippedGoods(model: e);
            //     }
            //   }
            //   setState(() {});
          },
        );
      },
      child: child,
    );
  }

  Future<void> onRefresh() async {
    final dataModel = await requestShopGoodsList();
    // UserInfoController.instance.balance = dataModel?.balance ?? 0;
    categorys = dataModel?.goodsList ?? [];
    updateTabController();

    final indicator = categorys.isNotEmpty ? IndicatorResult.success : IndicatorResult.fail;
    refreshController.finishRefresh(indicator);

    updateEquippedGoodsList();
  }

  /// 更新聊天气泡和进场特效
  void updateEquippedGoodsList() {
    // // 聊天气泡
    // final bubbleCategoryModel = categorys.firstWhere((e) => e.categoryEnum == GoodsCategoryEnum.bubble);
    // UserInfoController.instance.cacheEquippedGoods(model: bubbleCategoryModel.equippedModel);
    // // 进场特效
    // final ennterEffectCategoryModel = categorys.firstWhere((e) => e.categoryEnum == GoodsCategoryEnum.enter_effect);
    // UserInfoController.instance.cacheEquippedGoods(model: ennterEffectCategoryModel.equippedModel);
  }

  /// 查询所有礼物列表
  Future<ShopGoodsDataModel?> requestShopGoodsList() async {
    // final api = GoodsListApi();
    // final map = await api.fetch();
    final str = await rootBundle.loadString(Assets.dataShopGoods);
    final map = jsonDecode(str);
    if (map['code'] != 0 || map["data"] == null) {
      ToastUtil.show(map['msg']);
      return null;
    }
    final rootModel = ShopGoodsRootModel.fromJson(map);
    return rootModel.data;
  }
}
