import 'package:flutter/material.dart';

import 'package:flutter_templet_project/util/theme/app_color.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

class StackDemoThree extends StatefulWidget {
  const StackDemoThree({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<StackDemoThree> createState() => _StackDemoThreeState();
}

class _StackDemoThreeState extends State<StackDemoThree> {
  final scrollController = ScrollController();

  final provider = CategoryProviderThree();

  double _topOffset = -1;
  final _minTop = -1.0;
  final double _maxTop = 200.0;

  // bool _isExpanded = false;
  bool _isDragging = false;
  bool _userTouching = false;

  // bool isExpanded = false;
  // double topOffset = -1;

  void _handleDrag(DragUpdateDetails details) {
    _isDragging = true;
    _topOffset += details.delta.dy;
    // _topOffset = _topOffset.clamp(_maxTop, _minTop);

    provider.updateExpanded(false, _topOffset);
  }

  void _handleDragEnd(DragEndDetails details) {
    _isDragging = false;
    if (_topOffset < _minTop / 2) {
      _expand();
    } else {
      // _collapse();
    }
    setState(() {});
  }

  void _expand() {
    provider.updateExpanded(true, _maxTop);
  }

  void _collapse() {
    debugPrint("_collapse=$_minTop");
    provider.updateExpanded(false, _minTop);
    debugPrint("_collapseEnd=$_minTop");
  }

  double _lastScrollOffset = 0.0;
  bool _readyToCollapse = false;

  bool _onScrollNotification(ScrollNotification n) {
    DLog.d(n.runtimeType);

    if (n is ScrollStartNotification) {
      _isDragging = true;
      _userTouching = n.dragDetails != null;
    } else if (n is ScrollEndNotification) {
      _isDragging = false;
      _userTouching = false;
    }

    // 记录最近滚动位置
    if (n is ScrollUpdateNotification) {
      if (n.metrics.pixels > 0) {
        _readyToCollapse = false; // 离开顶部就重置
      }
      _lastScrollOffset = n.metrics.pixels;
    }

    // 没滚动但有下拉动作（Overscroll）
    if (n is OverscrollNotification) {
      if (n.overscroll < 0 && n.metrics.pixels <= 0 && provider.isExpanded && _userTouching) {
        debugPrint("Trigger collapse: overscroll=${n.overscroll}, offset=${n.metrics.pixels}");
        if (_readyToCollapse) {
          _collapse();
          return true;
        } else {
          _readyToCollapse = true; // 仅标记准备收缩
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$widget"),
        actions: [
          IconButton(
            onPressed: () {
              provider.isExpanded = !provider.isExpanded;
              setState(() {});
            },
            icon: Icon(Icons.currency_exchange),
          ),
        ],
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Scrollbar(
          controller: scrollController,
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                buildWrap(),
              ],
            ),
          ),
        ),
        ListenableBuilder(
          listenable: provider,
          builder: (context, Widget? child) {
            var top = provider.topOffset == -1 ? (provider.isExpanded ? _maxTop : _minTop) : provider.topOffset;

            final args = {
              "top": top.toStringAsFixed(1),
              "topOffset": provider.topOffset.toStringAsFixed(1),
            };
            return AnimatedPositioned(
              duration: const Duration(milliseconds: 150),
              top: top,
              left: 0,
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onVerticalDragUpdate: _handleDrag,
                onVerticalDragEnd: _handleDragEnd,
                child: NotificationListener<ScrollNotification>(
                  onNotification: _onScrollNotification,
                  child: HotScreenViewThree(arguments: args),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget buildWrap() {
    final list = List.generate(8, (i) => i);

    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      final spacing = 8.0;
      final rowCount = 4.0;
      final itemWidth = (constraints.maxWidth - spacing * (rowCount - 1)) / rowCount;

      return Wrap(
        spacing: spacing,
        runSpacing: spacing,
        // crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          ...list.map((e) {
            return Container(
              width: itemWidth,
              height: itemWidth * 1.2,
              decoration: BoxDecoration(
                color: Colors.lightGreen,
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.all(Radius.circular(0)),
              ),
              child: Text("item $e"),
            );
          }),
        ],
      );
    });
  }
}

class HotScreenViewThree extends StatefulWidget {
  const HotScreenViewThree({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<HotScreenViewThree> createState() => _HotScreenViewThreeState();
}

class _HotScreenViewThreeState extends State<HotScreenViewThree> {
  final scrollController = ScrollController();

  var indexVN = ValueNotifier(0);
  final leftItems = List.generate(10, (i) => (title: "Section$i", color: ColorExt.random));

  @override
  void didUpdateWidget(covariant HotScreenViewThree oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.bgColor,
        border: Border.all(color: Colors.blue),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.all(Radius.circular(0)),
            ),
          ),
          Row(
            children: [
              buildLeft(),
              Expanded(child: buildRight()),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildLeft() {
    return Container(
      width: 100,
      child: ListView.builder(
        itemCount: leftItems.length,
        itemBuilder: (_, i) {
          final e = leftItems[i];

          final isSelecetd = i == indexVN.value;

          return GestureDetector(
            onTap: () {
              indexVN.value = i;
              DLog.d(i);
              setState(() {});
            },
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: isSelecetd ? Colors.white : Colors.grey,
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.all(Radius.circular(0)),
              ),
              child: Text(e.title),
            ),
          );
        },
      ),
    );
  }

  Widget buildRight() {
    final e = leftItems[indexVN.value];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: e.color,
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Section ${indexVN.value}",
              style: TextStyle(fontSize: 20),
            ),
            Text(
              "arguments: ${widget.arguments}",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 8),
            buildWrap(),
          ],
        ),
      ),
    );
  }

  Widget buildWrap() {
    final list = List.generate(16, (i) => i);

    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      final spacing = 8.0;
      final rowCount = 4.0;
      final itemWidth = (constraints.maxWidth - spacing * (rowCount - 1)) / rowCount;

      return Wrap(
        spacing: spacing,
        runSpacing: spacing,
        // crossAxisAlignment: WrapCrossAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.start,
        children: [
          ...list.map((e) {
            return Container(
              width: itemWidth,
              height: itemWidth * 1.2,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.all(Radius.circular(0)),
              ),
              child: Text("card $e"),
            );
          }),
        ],
      );
    });
  }
}

class CategoryProviderThree with ChangeNotifier {
  final bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;

  String? get error => _error;

  bool isExpanded = false;
  double topOffset = -1;

  updateExpanded(bool isExpanded, [double? offset]) {
    this.isExpanded = isExpanded;
    if (offset != null) {
      topOffset = offset;
    } else {
      topOffset = -1;
    }
    notifyListeners();
  }
}
