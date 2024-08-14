import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:flutter_templet_project/util/R.dart';
import 'package:flutter_templet_project/basicWidget/page_indicator_widget.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';

class FlutterSwiperIndicatorDemo extends StatefulWidget {
  const FlutterSwiperIndicatorDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _FlutterSwiperIndicatorDemoState createState() =>
      _FlutterSwiperIndicatorDemoState();
}

class _FlutterSwiperIndicatorDemoState
    extends State<FlutterSwiperIndicatorDemo> {
  ValueNotifier<int> currentIndex = ValueNotifier(0);

  BorderRadius borderRadius = BorderRadius.all(Radius.circular(8));

  final items = R.image.urls;

  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
        ),
        body: _buildSwiper());
  }

  ///创建子项
  _buildItem(context, index) {
    final imgUrl = items[index];

    return InkWell(
      onTap: () => debugPrint(index),
      child: Container(
        // color: Colors.green,
        // width: this.itemWidth,
        padding: EdgeInsets.only(bottom: 0), //为了显示阴影
        child: ClipRRect(
          borderRadius: borderRadius,
          child: Stack(
            alignment: Alignment.center,
            fit: StackFit.expand,
            children: [
              FadeInImage(
                placeholder: AssetImage(
                  'assets/images/img_placeholder.png',
                ),
                image: NetworkImage(imgUrl),
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildSwiper() {
    return Container(
      height: 200,
      child: ClipRRect(
          borderRadius: borderRadius,
          child: Stack(
            children: [
              Swiper(
                  itemBuilder: (context, index) => _buildItem(context, index),
                  // indicatorLayout: PageIndicatorLayout.COLOR,
                  autoplay: items.length > 1,
                  loop: items.length > 1,
                  itemCount: items.length,
                  // pagination: this.items.length <= 1 ? null : SwiperPagination(),
                  // control: SwiperControl(),
                  // itemWidth: 200,
                  // viewportFraction: 0.6,
                  onIndexChanged: (index) {
                    currentIndex.value = index;
                  }),
              // if (this.items.length > 1) buildPageIndicator(),
              if (this.items.isNotEmpty)
                PageIndicatorWidget(
                  currentPage: currentIndex,
                  itemCount: items.length,
                  itemSize:
                      Size(context.screenSize.width / 4 / items.length, 2),
                  // itemBuilder: (isSelected, itemSize) {
                  //   return Container(
                  //     width: itemSize.width,
                  //     height: itemSize.height,
                  //     color: isSelected ? Colors.red : Colors.green,
                  //   );
                  // },
                )
            ],
          )),
    );
  }
}
