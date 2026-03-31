import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

class HorizalSwiperCardDemo extends StatefulWidget {
  const HorizalSwiperCardDemo({super.key});

  @override
  State<HorizalSwiperCardDemo> createState() => _HorizalSwiperCardDemoState();
}

class _HorizalSwiperCardDemoState extends State<HorizalSwiperCardDemo> with SingleTickerProviderStateMixin {
  final List<MaterialColor> items = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
  ];

  int currentIndex = 0;

  Offset offset = Offset.zero;

  late AnimationController controller;
  Animation<Offset>? animation;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  void _onPanUpdate(DragUpdateDetails details) {
    offset += details.delta;
    setState(() {});
  }

  void _onPanEnd(DragEndDetails details) {
    final width = MediaQuery.of(context).size.width;

    // 判定滑动是否成功
    if (offset.dx.abs() > width * 0.25) {
      _flyOut();
    } else {
      _backToCenter();
    }
  }

  /// 飞出动画
  void _flyOut() {
    final width = MediaQuery.of(context).size.width;

    final end = Offset(
      offset.dx > 0 ? width : -width,
      offset.dy,
    );

    animation = Tween(begin: offset, end: end).animate(controller)
      ..addListener(() {
        offset = animation!.value;
        setState(() {});
      });

    controller.forward(from: 0).then((_) {
      offset = Offset.zero;
      currentIndex++;
      if ((currentIndex + 3) > items.length) {
        items.add(Colors.primaries.random ?? Colors.pink);
      }
      setState(() {});
    });
  }

  /// 回弹动画
  void _backToCenter() {
    animation = Tween(begin: offset, end: Offset.zero).animate(controller)
      ..addListener(() {
        offset = animation!.value;
        setState(() {});
      });

    controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SwiperCardDemo')),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: _buildCards(),
        ),
      ),
    );
  }

  List<Widget> _buildCards() {
    final cards = <Widget>[];

    for (int i = currentIndex; i < currentIndex + 3; i++) {
      if (i >= items.length) {
        break;
      }

      final isTop = i == currentIndex;
      final bottom = (items.length - i) * 8.0;
      cards.add(
        Positioned.fill(
          bottom: bottom,
          child: Transform.translate(
            offset: isTop ? offset : Offset(0, (i - currentIndex) * 10),
            child: isTop ? _buildTopCard(i: i) : _buildCard(i: i),
          ),
        ),
      );
    }

    return cards.reversed.toList();
  }

  Widget _buildTopCard({
    required int i,
    VoidCallback? onLeft,
    VoidCallback? onRight,
  }) {
    final Color color = items[i];
    final angle = offset.dx / 300;

    return Transform.rotate(
      angle: angle,
      child: GestureDetector(
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        child: _buildCard(i: i, onLeft: onLeft, onRight: onRight),
      ),
    );
  }

  Widget _buildCard({
    required int i,
    VoidCallback? onLeft,
    VoidCallback? onRight,
  }) {
    final Color color = items[i];
    return Center(
      child: Container(
        width: 300,
        height: 420,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              blurRadius: 10,
              color: Colors.black26,
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              "$i",
              style: TextStyle(fontSize: 24),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FloatingActionButton(onPressed: onLeft ?? _flyOut, child: Icon(Icons.close)),
                FloatingActionButton(onPressed: onRight ?? _flyOut, child: Icon(Icons.check)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
