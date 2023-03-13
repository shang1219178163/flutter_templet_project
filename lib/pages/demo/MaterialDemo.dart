import 'package:flutter/material.dart';

class MaterialDemo extends StatefulWidget {

  MaterialDemo({
    Key? key, 
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _MaterialDemoState createState() => _MaterialDemoState();
}

class _MaterialDemoState extends State<MaterialDemo> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  var types = MaterialType.values;

  var type = MaterialType.values[0];

  final indexVN = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    _tabController ??= TabController(length: types.length, vsync: this);
    _tabController?.addListener(() {
      indexVN.value = _tabController!.index;
      print("indexVN:${indexVN.value}_${_tabController?.index}");
    });
  }

  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => print("done"),
        )).toList(),
        bottom: TabBar(
          isScrollable: true,
          controller: _tabController,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: types.map((e) => Tab(text: e.toString().split(".").last)).toList(),
        ),
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return SafeArea(
      child: CustomScrollView(
        slivers: <Widget>[
          Column(
            children: [
              Container(
                height: 500,
                width: double.infinity,
                padding: EdgeInsets.all(8),
                child: Wrap(
                  children: [
                    ElevatedButton(onPressed: onPressed, child: Text("button")),
                    ValueListenableBuilder(
                      valueListenable: indexVN,
                      builder: (context, value, child) {
                        print("ValueListenableBuilder:${indexVN.value}");

                        return _buildMaterialDemo();
                      }
                    ),
                  ],
                ),
              )
            ],
          ),
        ].map((e) => SliverToBoxAdapter(child: e)).toList(),
      ),
    );
  }

  onPressed() {

  }

  _buildMaterialDemo() {
    return Center(
      child: Material(
        type: type,
        elevation: 10,
        color: Colors.green,
        child: Opacity(
          opacity: 1,
          child: ElevatedButton(
            onPressed: (){
              print("ElevatedButton");
            },
            child: Text("ElevatedButton"),
          ),
        )
      ),
    );
  }

}