//
//  NestedScrollViewDemoTwo.dart
//  flutter_templet_project
//
//  Created by shang on 2023/3/25 08:43.
//  Copyright © 2023/3/25 shang. All rights reserved.
//


import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_sliver_persistent_header_delegate.dart';
import 'package:flutter_templet_project/extension/color_ext.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';
import 'package:flutter_templet_project/uti/R.dart';

class NestedScrollViewDemoTwo extends StatefulWidget {

  const NestedScrollViewDemoTwo({ Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _NestedScrollViewDemoTwoState createState() => _NestedScrollViewDemoTwoState();
}

class _NestedScrollViewDemoTwoState extends State<NestedScrollViewDemoTwo> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  ScrollController? _scrollController;

  List<String> items = List.generate(9, (index) => 'item_$index').toList();

  final indexVN = ValueNotifier<int>(0);

  final flagVN = ValueNotifier(false);

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: items.length, vsync: this);
    // _tabController?.addListener(() {
    //   indexVN.value = _tabController!.index;
    //   print("indexVN:${indexVN.value}_${_tabController?.index}");
    // });

    _scrollController = ScrollController(initialScrollOffset: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          onPressed: onPressed,
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),)
        ).toList(),
      ),
      body: _buildBody(),
    );
  }

  onPressed(){
    flagVN.value = !flagVN.value;
    setState(() {});
  }

  _buildBody() {
    if(flagVN.value) {
      return _buildBody2(
        scrollController: _scrollController,
        tabController: _tabController,
        indexVN: indexVN,
        items: items
      );
    }
    return _buildBody1(
      scrollController: _scrollController,
      tabController: _tabController,
      indexVN: indexVN,
      items: items
    );
  }

  _buildBody1({
    required ScrollController? scrollController,
    required TabController? tabController,
    required ValueNotifier<int> indexVN,
    required List<String> items,
  }) {
    return NestedScrollView(
      controller: scrollController,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          buildSliverOverlapAbsorber(
            context: context,
            innerBoxIsScrolled: innerBoxIsScrolled,
            controller: tabController,
            items: items,
          ),
        ];
      },
      body: TabBarView(
        controller: tabController,
        children: items.map((e) {
          return SafeArea(
            child: Builder(
              builder: (BuildContext context) {
                return CustomScrollView(
                  slivers: <Widget>[
                    SliverFillRemaining(
                      // child: e
                      child: Container(
                        color: ColorExt.random,
                        alignment: Alignment.center,
                        child: Text(e),
                      ),
                    )
                  ],
                );
              },
            ));
          }).toList(),
        ),
    );
  }

  _buildBody2({
    required ScrollController? scrollController,
    required TabController? tabController,
    required ValueNotifier<int> indexVN,
    required List<String> items,
  }) {
    return SafeArea(
      child: NestedScrollView(
        controller: scrollController,
        headerSliverBuilder: (context, _) => [
          SliverToBoxAdapter(
            child: Container(
              height: 100,
              color: Colors.blue,
            ),
          ),
        ],
        body: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: CustomScrollView(
            physics: const NeverScrollableScrollPhysics(),
            // controller: _scrollController,
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: NSliverPersistentHeaderDelegate(
                  max: 48,
                  builder: (context, offset, overlapsContent) {
                    return ColoredBox(
                      color: Colors.yellow,
                      child: Align(
                        alignment: Alignment.center,
                        child: ColoredBox(
                          color: Colors.deepOrange,
                          child: TabBar(
                            padding: EdgeInsets.zero,
                            // labelPadding: EdgeInsets.zero,
                            controller: _tabController,
                            isScrollable: true,
                            tabs: items.map((e) => Tab(child: Text(e),)).toList(),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SliverFillRemaining(
                child: buildTabBarView(controller: tabController, items: items),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildTabBar({
    required TabController? controller,
    required ValueNotifier<int> indexVN,
    required List<String> items,
    TabBarIndicatorSize? indicatorSize = TabBarIndicatorSize.label,
  }) {
    return TabBar(
      isScrollable: true,
      controller: controller,
      // indicatorSize: TabBarIndicatorSize.label,
      indicatorSize: indicatorSize,
      // labelPadding: EdgeInsets.symmetric(horizontal: 12),
      // indicatorPadding: EdgeInsets.only(left: 8, right: 8),
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(
          style: BorderStyle.solid,
          width: 4,
          color: Colors.red,
        )
      ),
      tabs: items.map((e) => Tab(
        child: ValueListenableBuilder<int>(
          valueListenable: indexVN,
          builder: (BuildContext context, int value, Widget? child) {
            final index = items.indexOf(e);
            if (index != 1){
              if (index == 2){
                return Tab(child: Text(e + e,),);
              }
              if (index == 3){
                return Tab(child: Text(e + e, style: TextStyle(fontSize: 20)),);
              }
              return Tab(text: e);
            }

            final url = (value == index) ? R.image.urls[1] : R.image.urls[0];
            return Tab(
              child: FadeInImage(
                image: NetworkImage(url),
                placeholder: "flutter_logo.png".toAssetImage(),
              ),
            );
          }),
      )).toList(),
    );
  }


  ///有小问题
  buildSliverOverlapAbsorber({
    required BuildContext context,
    bool innerBoxIsScrolled = false,
    TabController? controller,
    required List<String> items,
  }) {
    return SliverOverlapAbsorber(
      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
      sliver: SliverAppBar(
        automaticallyImplyLeading: false,
        pinned: true,
        floating: true,
        expandedHeight: 110.0,
        forceElevated: innerBoxIsScrolled,
        stretch: true,
        bottom: TabBar(
          controller: controller,
          isScrollable: true,
          tabs: items.map((e) => Tab(
            child: Text(e)
          )).toList(),
        )
      ),
    );
  }


  buildSliverFillRemaining() {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Container(
        color: Colors.black12,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('SliverFillRemaining'),
              Text('向上滑动时自动充满视图的剩余空间')
            ],
          ),
        ),
      ),
    );
  }

  SliverPersistentHeader buildSliverHeader({
    required Text text,
    bool pinned = true
  }) {
    return SliverPersistentHeader(
      pinned: pinned,
      delegate: NSliverPersistentHeaderDelegate(
        min: 60.0,
        max: 80.0,
        builder: (ctx, offset, overlapsContent) => SizedBox.expand(
          child: Container(
            decoration: BoxDecoration(
              // color: Colors.white,
              color: Colors.lightBlue,
              borderRadius: BorderRadius.all(Radius.circular(116)),
            ),
            child: Center(
              child: text,
            ),
          ),
        ),
      ),
    );
  }

  buildTabBarView({
    required TabController? controller,
    required List<String> items,
  }) {
    return TabBarView( //构建
      controller: controller,
      children: items.map((e) {
        return RefreshIndicator(
          onRefresh: () {
            debugPrint(('onRefresh'));
            return Future.delayed(Duration(microseconds: 1500));
          },
          child: buildList(),
        );
      }).toList(),
    );
  }

  buildList() {
    const items = Colors.primaries;
    return ListView.builder(
      // controller: _scrollController,
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index){
        final color = items[index];
        return ListTile(
          leading: Icon(Icons.ac_unit, color: color,),
          title: Text("$index"),
        );
      }
    );
  }

}