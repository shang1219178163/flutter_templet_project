import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:popover/popover.dart';


class PopoverDemo extends StatefulWidget {

  final String? title;
  const PopoverDemo({ Key? key, this.title}) : super(key: key);

  @override
  _PopoverDemoState createState() => _PopoverDemoState();
}

class _PopoverDemoState extends State<PopoverDemo> {

  bool isListStyle = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: [
          TextButton(onPressed: (){
            ddlog("change");
            setState(() {
              isListStyle = !isListStyle;
            });
          }, child: Icon(Icons.change_circle_outlined, color: Colors.white,)),
        ],
      ),
      body: SafeArea(
        child: isListStyle ? buildList() : buildBody(),
      ),
    );
  }

  Widget buildBody() {
    final items = List.generate(3, (index) => PopoverButton(text: Text("title_$index"),));
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: items,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: items,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: items,
          ),
        ],
      ),
    );
  }

  Widget buildList() {
    final list = List.generate(9, (index) => index.toString());
    return Scrollbar(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: ListView.separated(
            itemBuilder: (context, index) {
              final e = list[index];
              return ListTile(
                title: Text(e),
                // subtitle: const Text(e),
                trailing: const PopoverButton(text: Text("点击"),),
                dense: true,
                onTap: (){
                  print([DateTime.now(), e]);
                },
              );
            },
            itemCount: list.length,
            separatorBuilder: (context, index) {
              return const Divider(
                height: .5,
                indent: 15,
                endIndent: 15,
                color: Color(0xFFDDDDDD),
              );
            }
        ),
      ));
  }

  void _showMyPop(BuildContext context) {
    showPopover(
      context: context,
      transitionDuration: const Duration(milliseconds: 150),
      bodyBuilder: (context) => const ListItems(),
      onPop: () => print('Popover was popped!'),
      direction: PopoverDirection.bottom,
      width: 200,
      height: 400,
      arrowHeight: 15,
      arrowWidth: 30,
    );
  }
}

class PopoverButton extends StatelessWidget {
  final Text? text;
  const PopoverButton({Key? key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: 80,
        height: 40,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5)),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
        ),
        child: Center(
            child: text ?? Text(runtimeType.toString()),
        ),
      ),
      onTap: () {
        // _handleShowPopover(context);
        _handleShowPopover1(context);
        context.logRendBoxInfo();
      }
    );
  }


  void _handleShowPopover1(BuildContext context) {
    showPopover(
      context: context,
      transitionDuration: const Duration(milliseconds: 150),
      bodyBuilder: (context) => Container(
        // color: Colors.green,
        child: Row(
          children: [
            TextButton(onPressed: (){
              print([DateTime.now(), "按钮1"]);

            }, child: const Text("按钮1")),
            TextButton(onPressed: (){
              print([DateTime.now(), "按钮2"]);

            }, child: const Text("按钮2")),
            TextButton(onPressed: (){
              print([DateTime.now(), "按钮3"]);

            }, child: const Text("按钮3")),
          ],
        ),
      ),
      onPop: () => print('Popover was popped!'),
      direction: PopoverDirection.bottom,
      // width: 200,
      height: 60,
      arrowHeight: 10,
      arrowWidth: 15,
      arrowDyOffset: 2,
      barrierColor: Colors.black.withAlpha(30),
    );
  }

}


class ListItems extends StatelessWidget {
  const ListItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context)
                  ..pop()
                  ..push(
                    MaterialPageRoute<SecondRoute>(
                      builder: (context) => SecondRoute(),
                    ),
                  );
              },
              child: Container(
                height: 50,
                color: Colors.amber[100],
                child: const Center(child: Text('Entry A')),
              ),
            ),
            const Divider(),
            Container(
              height: 50,
              color: Colors.amber[200],
              child: const Center(child: Text('Entry B')),
            ),
            const Divider(),
            Container(
              height: 50,
              color: Colors.amber[300],
              child: const Center(child: Text('Entry C')),
            ),
            const Divider(),
            Container(
              height: 50,
              color: Colors.amber[400],
              child: const Center(child: Text('Entry D')),
            ),
            const Divider(),
            Container(
              height: 50,
              color: Colors.amber[500],
              child: const Center(child: Text('Entry E')),
            ),
            const Divider(),
            Container(
              height: 50,
              color: Colors.amber[600],
              child: const Center(child: Text('Entry F')),
            ),
          ],
        ),
      ),
    );
  }
}

class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Route'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}
