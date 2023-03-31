import 'package:flutter/material.dart';

class MaterialDemo extends StatefulWidget {

  const MaterialDemo({
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
  final typeVN = ValueNotifier(MaterialType.values[0]);

  @override
  void initState() {
    super.initState();
    _tabController ??= TabController(length: types.length, vsync: this);
    _tabController?.addListener(() {
      final idx = _tabController!.index;
      indexVN.value = idx;
      typeVN.value = types[idx];
      debugPrint("indexVN:${indexVN.value}_${typeVN.value}");
    });
  }

  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          onPressed: () => debugPrint("done"),
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),
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
                    // ElevatedButton(onPressed: onPressed, child: Text("button")),
                    ...types.map((e) => Padding(
                      padding: EdgeInsets.all(10),
                      child: Material(
                        type: e,
                        color: Colors.red,
                        elevation: 10,
                        shadowColor: Colors.blue,
                        child: Container(
                          alignment: Alignment.center,
                          height: 60,
                          width: 70,
                          decoration: BoxDecoration(
                            border: Border.all()
                          ),
                          child: InkWell(
                            onTap: () {
                              debugPrint("Press: ${e.toString().split(".")[1]}");
                            },
                            child: Text(e.toString().split(".")[1]),                          ),
                        ),),
                    )).toList(),
                    ValueListenableBuilder<MaterialType>(
                      valueListenable: typeVN,
                      builder: (context, value, child) {
                        debugPrint("ValueListenableBuilder:$value");

                        return _buildMaterialDemo(type: value);
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

  _buildMaterialDemo({MaterialType type = MaterialType.button}) {
    return Center(
      child: Material(
        type: type,
        elevation: 10,
        color: Colors.green,
        child: Opacity(
          opacity: 1,
          child: TextButton(
            onPressed: (){
              debugPrint("ElevatedButton");
            },
            child: Text("ElevatedButton"),
          ),
        )
      ),
    );
  }

}
