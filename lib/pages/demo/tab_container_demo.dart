//
//  TabContainerDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2025/1/22 15:20.
//  Copyright © 2025/1/22 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_swiper_gesture_detector.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:get/get.dart';
import 'package:tab_container/tab_container.dart';

/// tab_container demo
class TabContainerDemo extends StatefulWidget {
  const TabContainerDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<TabContainerDemo> createState() => _TabContainerDemoState();
}

class _TabContainerDemoState extends State<TabContainerDemo> with SingleTickerProviderStateMixin {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final _scrollController = ScrollController();

  Map<String, dynamic> arguments = Get.arguments ?? <String, dynamic>{};

  late final TabController _controller = TabController(vsync: this, length: kCreditCards.length);
  late TextTheme textTheme;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    textTheme = Theme.of(context).textTheme;
    super.didChangeDependencies();
  }

  /// 后退
  onPre() {
    if (_controller.index == 0) {
      return;
    }
    _controller.index -= 1;
  }

  /// 前进
  onNext() {
    if (_controller.index == _controller.length - 1) {
      return;
    }
    _controller.index += 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hideApp
          ? null
          : AppBar(
              title: Text("$widget"),
            ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Container(
          // height: 2000,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              NSwiperGestureDetector(
                onPre: onPre,
                onNext: onNext,
                child: Image.network(
                  'https://fastly.jsdelivr.net/npm/@vant/assets/apple-1.jpeg',
                ),
              ),
              buildCardBox(),
              buildCarBox(),
              buildTabRight(),
              buildTabLeft(),
            ]
                .map((e) => Container(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: Colors.blue),
                      ),
                      child: e,
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }

  /// 银行卡效果
  Widget buildCardBox() {
    List<Widget> _getChildren1() {
      List<CreditCardData> cards = kCreditCards.map((e) => CreditCardData.fromJson(e)).toList();

      return cards.map((e) => CreditCard(data: e)).toList();
    }

    List<Widget> _getTabs1() {
      List<CreditCardData> cards = kCreditCards.map((e) => CreditCardData.fromJson(e)).toList();
      return cards.map((e) => Text('*${e.number.substring(e.number.length - 4, e.number.length)}')).toList();
    }

    return SizedBox(
      width: 400,
      child: AspectRatio(
        aspectRatio: 10 / 8,
        child: TabContainer(
          controller: _controller,
          borderRadius: BorderRadius.circular(20),
          tabEdge: TabEdge.bottom,
          curve: Curves.easeIn,
          // transitionBuilder: (child, animation) {
          //   animation = CurvedAnimation(curve: Curves.easeIn, parent: animation);
          //   return SlideTransition(
          //     position: Tween(begin: const Offset(0.2, 0.0), end: const Offset(0.0, 0.0)).animate(animation),
          //     child: FadeTransition(opacity: animation, child: child),
          //   );
          // },
          colors: const <Color>[
            Color(0xfffa86be),
            Color(0xffa275e3),
            Color(0xff9aebed),
            Colors.blue,
          ],
          selectedTextStyle: textTheme.bodyMedium?.copyWith(fontSize: 15.0),
          unselectedTextStyle: textTheme.bodyMedium?.copyWith(fontSize: 13.0),
          tabs: _getTabs1(),
          children: _getChildren1().map((e) {
            return NSwiperGestureDetector(
              onPre: onPre,
              onNext: onNext,
              child: e,
            );
          }).toList(),
        ),
      ),
    );
  }

  /// Tab 效果
  Widget buildCarBox() {
    List<Widget> _getChildren2() {
      return <Widget>[
        Image.network(
            'https://images.unsplash.com/photo-1552519507-da3b142c6e3d?q=80&w=400&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
        Image.network(
            'https://images.unsplash.com/photo-1494905998402-395d579af36f?q=80&w=400&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
        Image.network(
            'https://images.unsplash.com/photo-1583121274602-3e2820c69888?q=80&w=400&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
        Image.network(
          'https://fastly.jsdelivr.net/npm/@vant/assets/apple-1.jpeg',
        ),
      ];
    }

    List<Widget> _getTabs2() {
      return List.generate(4, (i) => Text('选项 $i'));
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TabContainer(
          controller: _controller,
          borderRadius: BorderRadius.zero,
          tabBorderRadius: BorderRadius.zero,
          color: Colors.blue,
          duration: const Duration(seconds: 0),
          selectedTextStyle: textTheme.bodyMedium?.copyWith(color: Colors.white),
          unselectedTextStyle: textTheme.bodyMedium?.copyWith(color: Colors.black),
          tabs: _getTabs2(),
          children: _getChildren2().map((e) {
            return NSwiperGestureDetector(
              onPre: onPre,
              onNext: onNext,
              child: e,
            );
          }).toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: onPre,
              icon: const Icon(Icons.arrow_back),
            ),
            IconButton(
              onPressed: onNext,
              icon: const Icon(Icons.arrow_forward),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildTabRight() {
    List<Widget> _getChildren3(BuildContext context) => <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Info', style: Theme.of(context).textTheme.headlineSmall),
              const Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam non ex ac metus facilisis pulvinar. In id nulla tellus. Donec vehicula iaculis lacinia. Fusce tincidunt viverra nisi non ultrices. Donec accumsan metus sed purus ullamcorper tincidunt. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas.',
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Documents', style: Theme.of(context).textTheme.headlineSmall),
              const Spacer(flex: 2),
              const Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Divider(thickness: 1),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text('Document 1'),
                    ),
                    Divider(thickness: 1),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text('Document 2'),
                    ),
                    Divider(thickness: 1),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text('Document 3'),
                    ),
                    Divider(thickness: 1),
                  ],
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Profile', style: Theme.of(context).textTheme.headlineSmall),
              const Spacer(flex: 3),
              const Expanded(
                flex: 3,
                child: Row(
                  children: [
                    Flexible(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('username:'),
                          Text('email:'),
                          Text('birthday:'),
                        ],
                      ),
                    ),
                    Spacer(),
                    Flexible(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('John Doe'),
                          Text('john.doe@email.com'),
                          Text('1/1/1985'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Settings', style: Theme.of(context).textTheme.headlineSmall),
              const Spacer(flex: 1),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SwitchListTile(
                      title: const Text('Darkmode'),
                      value: false,
                      onChanged: (v) {},
                      secondary: const Icon(Icons.nightlight_outlined),
                    ),
                    SwitchListTile(
                      title: const Text('Analytics'),
                      value: false,
                      onChanged: (v) {},
                      secondary: const Icon(Icons.analytics),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ];

    List<Widget> _getTabs3(BuildContext context) => <Widget>[
          const Icon(Icons.info),
          const Icon(Icons.text_snippet),
          const Icon(Icons.person),
          const Icon(Icons.settings),
        ];

    return SizedBox(
      width: 400,
      height: 400,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: TabContainer(
          controller: _controller,
          color: Theme.of(context).colorScheme.secondary,
          tabEdge: TabEdge.right,
          childPadding: const EdgeInsets.all(20.0),
          tabs: _getTabs3(context),
          children: _getChildren3(context),
        ),
      ),
    );
  }

  Widget buildTabLeft() {
    Widget _buildPage({required String title, required String content}) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
            Text(
              content,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      );
    }

    List<String> _getcontents() => <String>[
          '''Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur scelerisque, est ac suscipit interdum, leo lacus ultrices metus, eget tristique metus velit eget nisi. Cras ut sagittis libero, in volutpat erat. Proin luctus turpis nec molestie congue. Nam et mollis augue. Duis ornare odio vel egestas lacinia. Nam luctus venenatis diam sollicitudin elementum. Duis laoreet, mi quis luctus lacinia, nunc mauris auctor turpis, ac condimentum felis augue at purus. Integer eu dolor vehicula odio elementum vulputate vel non neque.
        Vestibulum et sapien sed quam euismod rutrum. Phasellus molestie dignissim ullamcorper. Donec eleifend sapien egestas tincidunt ornare. Pellentesque elit leo, bibendum nec augue nec, faucibus eleifend nisi. In blandit nulla sit amet congue tincidunt. Etiam dictum ornare justo, vulputate aliquam nisi egestas id. Nulla diam ipsum, pretium vitae leo et, fringilla mollis arcu. Praesent ut ipsum malesuada, posuere quam non, consectetur sem. Aenean velit dolor, laoreet sit amet lacinia quis, porta vitae tortor. Pellentesque scelerisque lacus nec velit finibus pharetra. Donec lacus arcu, consectetur eget nibh ac, viverra mollis nunc. Morbi auctor condimentum odio, ut laoreet neque maximus et. Mauris ut magna ipsum.''',
          '''Duis in tortor nisl. Vestibulum vitae ullamcorper urna. Aliquam at consequat mi, sit amet ultricies mauris. Nam volutpat risus mollis tortor porta volutpat. Fusce sollicitudin felis in interdum finibus. Nam ultrices volutpat posuere. Quisque eget mattis nulla. Cras sit amet consequat erat. Nam consectetur urna sem, eget faucibus quam tincidunt sed. Cras congue diam vitae turpis tristique, ut commodo nunc placerat. Nunc id risus mattis, cursus erat in, dignissim mauris.
Donec ac libero arcu. Pellentesque sollicitudin mi et lectus interdum, sit amet dignissim turpis laoreet. Aenean id sapien at felis fermentum faucibus. Fusce suscipit, odio eget vestibulum rutrum, magna nibh sagittis felis, auctor blandit tortor diam et augue. Etiam sit amet mi fermentum, sollicitudin dolor sit amet, viverra lectus. Curabitur non leo vulputate, gravida urna non, maximus lacus. Maecenas a suscipit lacus. Donec pharetra laoreet lacus, non sagittis ante aliquet eget. Sed fermentum eros a nunc molestie imperdiet. Ut quis massa vitae sem vehicula facilisis at eget eros. Proin facilisis eu dolor eu ultricies. Etiam rhoncus arcu nec diam malesuada, in malesuada ipsum rhoncus. Nunc convallis fermentum purus. Sed lobortis purus sit amet ante blandit pharetra. Cras ut turpis sem. Vivamus vel felis in elit fringilla laoreet.''',
          '''Phasellus a rutrum lectus. Maecenas turpis nisi, imperdiet non tellus eget, aliquam bibendum urna. Nullam 
       tincidunt aliquam sem, eget finibus mauris commodo nec. Sed pharetra varius augue, id dignissim tortor vulputate at. Nunc sodales, nisl a ornare posuere, dolor purus pulvinar nulla, vel facilisis magna justo id tortor. Aliquam tempus nulla diam, non faucibus ligula cursus id. Maecenas vitae lorem augue. Aliquam hendrerit urna quis mi ornare pharetra. Duis vitae urna porttitor, porta elit a, egestas nibh. Etiam sollicitudin tincidunt sem pellentesque fringilla. Aenean sed mauris non augue hendrerit volutpat. Praesent consectetur metus ex, eu feugiat risus rhoncus sed. Suspendisse dapibus, nunc vel rhoncus placerat, tellus odio tincidunt mi, sed sagittis dui nulla eu erat.''',
          '''Phasellus a rutrum lectus. Maecenas turpis nisi, imperdiet non tellus eget, aliquam bibendum urna. Nullam tincidunt aliquam sem, eget finibus mauris commodo nec. Sed pharetra varius augue, id dignissim tortor vulputate at. Nunc sodales, nisl a ornare posuere, dolor purus pulvinar nulla, vel facilisis magna justo id tortor. Aliquam tempus nulla diam, non faucibus ligula cursus id. Maecenas vitae lorem augue. Aliquam hendrerit urna quis mi ornare pharetra. Duis vitae urna porttitor, porta elit a, egestas nibh. Etiam sollicitudin tincidunt sem pellentesque fringilla. Aenean sed mauris non augue hendrerit volutpat. Praesent consectetur metus ex, eu feugiat risus rhoncus sed. Suspendisse dapibus, nunc vel rhoncus placerat, tellus odio tincidunt mi, sed sagittis dui nulla eu erat.''',
        ];

    List<({Widget title, Widget page})> _getTabs4() {
      return [
        (title: Text('页面1'), page: _buildPage(title: "页面1", content: _getcontents()[0])),
        (title: Text('页面2'), page: _buildPage(title: "页面2", content: _getcontents()[1])),
        (title: Text('页面3'), page: _buildPage(title: "页面3", content: _getcontents()[2])),
        (title: Text('页面4'), page: _buildPage(title: "页面4", content: _getcontents()[3])),
      ];
    }

    return SizedBox(
      width: 400,
      height: 400,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: TabContainer(
          controller: _controller,
          color: Theme.of(context).colorScheme.primary,
          tabEdge: TabEdge.left,
          tabsStart: 0.1,
          tabsEnd: 0.6,
          childPadding: const EdgeInsets.all(20.0),
          tabs: _getTabs4().map((e) => e.title).toList(),
          // tabExtent: 80,
          selectedTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 15.0,
          ),
          unselectedTextStyle: const TextStyle(
            color: Colors.black,
            fontSize: 13.0,
          ),
          children: _getTabs4().map((e) => e.page).toList(),
        ),
      ),
    );
  }
}

class CreditCard extends StatelessWidget {
  final Color? color;
  final CreditCardData data;

  const CreditCard({
    super.key,
    this.color,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14.0),
      ),
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(data.bank),
                const Icon(Icons.person, size: 36),
              ],
            ),
          ),
          const Spacer(flex: 2),
          Expanded(
            flex: 5,
            child: Row(
              children: [
                Text(
                  data.number,
                  style: const TextStyle(
                    fontSize: 22.0,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Exp.'),
                const SizedBox(width: 4),
                Text(data.expiration),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Text(
                  data.name,
                  style: const TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CreditCardData {
  int index;
  bool locked;
  final String bank;
  final String name;
  final String number;
  final String expiration;
  final String cvc;

  CreditCardData({
    this.index = 0,
    this.locked = false,
    required this.bank,
    required this.name,
    required this.number,
    required this.expiration,
    required this.cvc,
  });

  factory CreditCardData.fromJson(Map<String, dynamic> json) => CreditCardData(
        index: json['index'],
        bank: json['bank'],
        name: json['name'],
        number: json['number'],
        expiration: json['expiration'],
        cvc: json['cvc'],
      );
}

const List<Map<String, dynamic>> kCreditCards = [
  {
    'index': 0,
    'bank': 'Aerarium',
    'name': 'John Doe',
    'number': '5234 4321 1234 4321',
    'expiration': '11/25',
    'cvc': '123',
  },
  {
    'index': 1,
    'bank': 'Aerarium',
    'name': 'John Doe',
    'number': '4234 4321 1234 4322',
    'expiration': '07/24',
    'cvc': '321',
  },
  {
    'index': 2,
    'bank': 'Aerarium',
    'name': 'John Doe',
    'number': '5234 4321 1234 4323',
    'expiration': '09/23',
    'cvc': '456',
  },
  {
    'index': 3,
    'bank': 'Aerarium',
    'name': 'John Doe',
    'number': '5234 4321 1234 4324',
    'expiration': '09/23',
    'cvc': '456',
  },
];
