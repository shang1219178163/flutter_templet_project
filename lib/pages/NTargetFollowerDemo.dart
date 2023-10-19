

import 'package:flutter/material.dart';

import 'package:flutter_templet_project/basicWidget/NTargetFollower.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';

class NTargetFollowerDemo extends StatefulWidget {

  NTargetFollowerDemo({
    Key? key,
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _NTargetFollowerDemoState createState() => _NTargetFollowerDemoState();
}

class _NTargetFollowerDemoState extends State<NTargetFollowerDemo> {

  final _scrollControlller = ScrollController();

  final List<OverlayEntry> entries = [];

  Function? _onHide;

  @override
  void initState() {
    _scrollControlller.addListener(() {
      _onHide?.call();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => debugPrint(e),)
        ).toList(),
      ),
      body: buildBody()
    );
  }

  buildBody() {
    return Container(
      child: Scrollbar(
        controller: _scrollControlller,
        child: ListView.separated(
          controller: _scrollControlller,
          itemCount: 20,
          itemBuilder: (context, i) {
            return Container(
              height: 75,
              child: ListTile(
                title: Text("row_$i"*20),
                trailing: i%3 != 0 ? null : NTargetFollower(
                  targetAnchor: Alignment.topRight,
                  followerAnchor: Alignment.bottomRight,
                  entries: entries,
                  onLongPressEnd: (e){

                  },
                  target: OutlinedButton(
                    onPressed: (){
                      debugPrint("button_$i");
                    },
                    child: Text("button_$i"),
                  ),
                  follower: Container(
                    // width: 200,
                    height: 35,
                    constraints: BoxConstraints(
                      // minHeight: 30,
                      // maxHeight: 300,
                      minWidth: 50,
                      maxWidth: 300,
                    ),
                    color: Colors.red,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: 2,
                      itemBuilder: (context, i) {

                        return ElevatedButton(
                          onPressed: (){
                            debugPrint("item_$i");
                          },
                          child: Text("item_$i"),
                        );
                      },
                      separatorBuilder: (context, i) {
                        return Divider(height: 1,);
                      },
                    ),
                  ),
                  followerBuilder: (context, onHide) {
                    _onHide = onHide;
                    return Container(
                      // width: 200,
                      // height: 100,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        // border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.all(Radius.circular(0)),
                      ),
                      constraints: BoxConstraints(
                        maxWidth: 300,
                        minWidth: 0,
                      ),
                      child: Wrap(
                        children: List.generate(9, (i) => i).map((e) {
                          return OutlinedButton(
                              onPressed: (){
                                debugPrint("button_$e");
                                if (e == 2) {
                                  onHide();
                                }
                              },
                              child: Text("button_$e"),
                          );
                        }).toList(),
                      ),
                    );
                  }
                ),
              ),
            );
          },
          separatorBuilder: (context, i) {
            return Divider(height: 1,);
          },
        ),
      ),
    );
  }

}