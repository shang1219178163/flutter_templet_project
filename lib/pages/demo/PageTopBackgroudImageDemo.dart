import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PageTopBackgroudImageDemo extends StatefulWidget {
  const PageTopBackgroudImageDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<PageTopBackgroudImageDemo> createState() => _PageTopBackgroudImageDemoState();
}

class _PageTopBackgroudImageDemoState extends State<PageTopBackgroudImageDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final scrollController = ScrollController();

  Map<String, dynamic> arguments = Get.arguments ?? <String, dynamic>{};

  /// id
  late final id = arguments["id"];

  @override
  void didUpdateWidget(covariant PageTopBackgroudImageDemo oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue),
        color: Theme.of(context).scaffoldBackgroundColor,
        image: DecorationImage(
          alignment: Alignment.topCenter,
          image: AssetImage("assets/images/bg_page_top_light.png"),
          fit: BoxFit.fitWidth,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("$widget"),
          backgroundColor: Colors.transparent,
        ),
        body: buildBody(),
      ),
    );
  }

  Widget buildBody() {
    return Scrollbar(
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            Text("$widget"),
          ],
        ),
      ),
    );
  }
}
