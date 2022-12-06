import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:flutter_templet_project/basicWidget/custom_swiper.dart';
import 'package:tuple/tuple.dart';

class FlutterSwiperDemo extends StatefulWidget {

  final String? title;

  FlutterSwiperDemo({ Key? key, this.title}) : super(key: key);

  
  @override
  _FlutterSwiperDemoState createState() => _FlutterSwiperDemoState();
}

class _FlutterSwiperDemoState extends State<FlutterSwiperDemo> {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: _buildListView(context),
    );
  }

  Widget _buildListView(BuildContext context) {
    return ListView.separated(
        itemCount: _list.length,
        separatorBuilder: (context, index) {
          return Divider(
            color: Colors.green,
          );
        },
        itemBuilder: (context, index) {
          final e = _list[index];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return e.item3;
                  }
              ));
            },
            child: ListTile(
              title: Text(e.item1),
              subtitle: Text(e.item2),
            ),
          );
        });
  }

}



List<Tuple3<String, String, Widget>> _list = [
  Tuple3(
    '/ExampleHorizontal',
    '',
    ExampleHorizontal(),
  ),
  Tuple3(
    'ExampleVertical',
    '',
    ExampleVertical(),
  ),
  Tuple3(
    'ExampleFraction',
    '',
    ExampleFraction(),
  ),
  Tuple3(
    'ExampleCustomPagination',
    '',
    ExampleCustomPagination(),
  ),
  Tuple3(
    'ExamplePhone',
    '',
    ExamplePhone(),
  ),
];


final List<String> images = [
  "https://cdn.pixabay.com/photo/2016/09/04/08/13/harbour-crane-1643476_1280.jpg",
  "https://cdn.pixabay.com/photo/2022/09/01/09/31/sunset-glow-7425170_1280.jpg",
  "https://cdn.pixabay.com/photo/2018/02/01/21/00/tree-3124103_1280.jpg",
  'https://pic.616pic.com/bg_w1180/00/04/08/G5Bftx5ZDI.jpg!/fw/1120',
  'https://pic.616pic.com/bg_w1180/00/07/20/2gfqq0N3qX.jpg!/fw/1120',
];

const List<String> titles = [
  "Flutter Swiper is awosome",
  "Really nice",
  "Yeap"
];

class ExampleHorizontal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /// 扩展属性 MediaQuery.of(this.context).size
    final screenSize = MediaQuery.of(context).size;

    return new Scaffold(
        appBar: AppBar(
          title: Text("ExampleHorizontal"),
        ),
        body: Swiper(
          itemBuilder: (BuildContext context, int index) {
            return CustomSwiperItem(
              url: images[index],
              color: index.isEven ? Colors.green : Colors.yellow,
            );
          },
          indicatorLayout: PageIndicatorLayout.COLOR,
          autoplay: true,
          itemCount: images.length,
          pagination: SwiperPagination(),
          control: SwiperControl(),
          // itemWidth: screenSize.width * 0.5,
          // viewportFraction: 0.6,
        )
    );
  }
}

class ExampleVertical extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("ExampleVertical"),
        ),
        body: Swiper(
          itemBuilder: (BuildContext context, int index) {
            return CustomSwiperItem(
              url: images[index],
              color: index.isEven ? Colors.green : Colors.yellow,
            );
          },
          autoplay: true,
          itemCount: images.length,
          scrollDirection: Axis.vertical,
          pagination: SwiperPagination(alignment: Alignment.centerRight),
          control: SwiperControl(),
        ));
  }
}

class ExampleFraction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          title: Text("ExampleFraction"),
        ),
        body: Column(
          children: <Widget>[
            _buildSwiper(),
            // // _buildSwiper1(),
            _buildSwiper2(),
            // _buildSwiper25(),
            _buildSwiper3(),
            // _buildSwiper4(),

            _buildCustomeBanner(),
          ],
        )
    );
  }

  _buildSwiper() {
    return  Expanded(
        child: Swiper(
          itemBuilder: (BuildContext context, int index) {
            return Container(
              child: CustomSwiperItem(
                url: images[index],
                color: index.isEven ? Colors.green : Colors.yellow,
              ),
            );
          },
          // autoplay: true,
          itemCount: images.length,
          pagination: SwiperPagination(builder: SwiperPagination.fraction),
          control: SwiperControl(),
          viewportFraction: 0.8,
          scale: 0.9,
          onTap: (index) => print(index),
        )
    );
  }

  _buildSwiper1() {
    return  Expanded(
        child: Swiper(
          itemBuilder: (BuildContext context, int index) {
            double left = index == 0 ? 20 : 0;
            double right = index == (images.length - 1) ? 20 : 0;

            EdgeInsets padding = EdgeInsets.only(left: left, right: right, top: 0, bottom: 0);
            EdgeInsets margin = EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0);
            if (![0, images.length - 1].contains(index)) {
              margin = EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0);
            }
            return Container(
              margin: margin,
              padding: padding,
              child: CustomSwiperItem(
                url: images[index],
                color: index.isEven ? Colors.green : Colors.yellow,
              ),
            );
          },
          // autoplay: true,
          itemCount: images.length,
          pagination: SwiperPagination(builder: SwiperPagination.fraction),
          control: SwiperControl(),
          viewportFraction: 1,
          onTap: (index) => print(index),
        )
    );
  }

  _buildSwiper2() {
    return Expanded(
        child: Swiper(
          itemBuilder: (BuildContext context, int index) {
            return CustomSwiperItem(
              url: images[index],
              color: index.isEven ? Colors.green : Colors.yellow,
            );
          },
          // autoplay: true,
          itemCount: images.length,
          pagination: SwiperPagination(builder: SwiperPagination.fraction),
          control: SwiperControl(),
          // containerWidth: 100,
          viewportFraction: 1/2,
        )
    );
  }

  _buildSwiper25() {
    return Expanded(
        child: Swiper(
          itemBuilder: (BuildContext context, int index) {
            return CustomSwiperItem(
              url: images[index],
              color: index.isEven ? Colors.green : Colors.yellow,
            );
          },
          // autoplay: true,
          itemCount: images.length,
          pagination: SwiperPagination(builder: SwiperPagination.fraction),
          control: SwiperControl(),
          // containerWidth: 100,
          viewportFraction: 1/2.5,
        )
    );
  }

  _buildSwiper3() {
    return Expanded(
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return CustomSwiperItem(
            url: images[index],
            color: index.isEven ? Colors.green : Colors.yellow,
          );
        },
        autoplay: true,
        itemCount: images.length,
        pagination: SwiperPagination(builder: SwiperPagination.fraction),
        control: SwiperControl(),
        viewportFraction: 1/3,
      ),
    );
  }

  _buildSwiper4() {
    final customLayoutOption = CustomLayoutOption(
        startIndex: -1,  /// 开始下标
        stateCount: 3    /// 下面的数组长度
    ).addRotate([        //  每个元素的角度
      -45.0/180,
      0.0,
      45.0/180
    ]).addTranslate([           /// 每个元素的偏移
      Offset(-370.0, -40.0),
      Offset(0.0, 0.0),
      Offset(370.0, -40.0)
    ]);

    return Expanded(
      child: Swiper(
        layout: SwiperLayout.CUSTOM,
        customLayoutOption: CustomLayoutOption(
            startIndex: -1,
            stateCount: 3
        ).addRotate([
          -45.0/180,
          0.0,
          45.0/180
        ]).addTranslate([
          Offset(-370.0, -40.0),
          Offset(0.0, 0.0),
          Offset(370.0, -40.0)
        ]),
        itemWidth: 300.0,
        itemHeight: 200.0,
        itemBuilder: (BuildContext context, int index) {
          return CustomSwiperItem(
            url: images[index],
            color: index.isEven ? Colors.green : Colors.yellow,
          );
        },
        itemCount: images.length,
      ),
    );
  }

  _buildCustomeBanner() {

    return Expanded(
      child: CustomSwipper(
        images: images,
        onTap: (int index) {
          print('CustomBanner 当前 page 为 ${index}');
        },
        // itemBuilder: (BuildContext context, int index) {
        //
        // },
      ),
    );
  }
}

class ExampleCustomPagination extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Custom Pagination"),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return Image.asset(
                    images[index],
                    fit: BoxFit.fill,
                  );
                },
                autoplay: true,
                itemCount: images.length,
                pagination: SwiperPagination(
                    margin: EdgeInsets.all(0.0),
                    builder: SwiperCustomPagination(builder:
                        (BuildContext context, SwiperPluginConfig config) {
                      return ConstrainedBox(
                        child: Container(
                            color: Colors.white,
                            child: Text(
                              "${titles[config.activeIndex]} ${config.activeIndex + 1}/${config.itemCount}",
                              style: TextStyle(fontSize: 20.0),
                            )),
                        constraints: BoxConstraints.expand(height: 50.0),
                      );
                    })),
                control: SwiperControl(),
              ),
            ),
            Expanded(
              child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return Image.asset(
                    images[index],
                    fit: BoxFit.fill,
                  );
                },
                autoplay: true,
                itemCount: images.length,
                pagination: SwiperPagination(
                    margin: EdgeInsets.all(0.0),
                    builder: SwiperCustomPagination(builder:
                        (BuildContext context, SwiperPluginConfig config) {
                      return ConstrainedBox(
                        child: Row(
                          children: <Widget>[
                            Text(
                              "${titles[config.activeIndex]} ${config.activeIndex + 1}/${config.itemCount}",
                              style: TextStyle(fontSize: 20.0),
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: DotSwiperPaginationBuilder(
                                    color: Colors.black12,
                                    activeColor: Colors.black,
                                    size: 10.0,
                                    activeSize: 20.0)
                                    .build(context, config),
                              ),
                            )
                          ],
                        ),
                        constraints: BoxConstraints.expand(height: 50.0),
                      );
                    })),
                control: SwiperControl(color: Colors.redAccent),
              ),
            )
          ],
        ));
  }
}

class ExamplePhone extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Phone"),
      ),
      body: Stack(
        children: <Widget>[
          ConstrainedBox(
            constraints: BoxConstraints.expand(),
            child: Image.asset(
              "images/bg.jpeg",
              fit: BoxFit.fill,
            ),
          ),
          Swiper.children(
            autoplay: false,
            pagination: SwiperPagination(
                margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 30.0),
                builder: DotSwiperPaginationBuilder(
                    color: Colors.white30,
                    activeColor: Colors.white,
                    size: 20.0,
                    activeSize: 20.0)),
            children: <Widget>[
              Image.asset(
                "images/1.png",
                fit: BoxFit.contain,
              ),
              Image.asset(
                "images/2.png",
                fit: BoxFit.contain,
              ),
              Image.asset("images/3.png", fit: BoxFit.contain)
            ],
          )
        ],
      ),
    );
  }
}

class ScaffoldWidget extends StatelessWidget {
  final Widget? child;
  final String? title;
  final List<Widget>? actions;

  ScaffoldWidget({this.child, this.title, this.actions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? ''),
        actions: actions,
      ),
      body: child,
    );
  }
}


class CustomSwiperItem extends StatelessWidget {

  const CustomSwiperItem({
    Key? key,
    this.color = Colors.white,
    this.padding = const EdgeInsets.all(0),
    this.margin = const EdgeInsets.all(0),
    required this.url,

  }) : super(key: key);

  final String url;
  final Color color;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: this.color,
      padding: this.padding,
      margin: this.margin,
      child: FadeInImage.assetNetwork(
        placeholder: 'images/img_placeholder.png',
        image: this.url,
        fit: BoxFit.fill,
      ),
    );
  }
}
