


import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/header.dart';
import 'package:tuple/tuple.dart';

class FloatingActionButtonDemo extends StatefulWidget {

  FloatingActionButtonDemo({
    Key? key,
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _FloatingActionButtonDemoState createState() => _FloatingActionButtonDemoState();
}

class _FloatingActionButtonDemoState extends State<FloatingActionButtonDemo> {


  @override
  Widget build(BuildContext context) {
    late final items = <Tuple2<String, Widget>>[
      Tuple2("buildButtonSmall", buildButtonSmall()),
      Tuple2("buildButton", buildButton(),),
      Tuple2("buildButtonLarge", buildButtonLarge(),),
      Tuple2("buildButtonExtended", buildButtonExtended(),),
      Tuple2("buildButtonExtendedCustom", buildButtonExtendedCustom(),),
    ];

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
      body: buildBody(
        items: items,
      ),
    );
  }

  buildBody({required List<Tuple2<String, Widget>> items}) {
    return Column(
      children: [
        SingleChildScrollView(
          child: Column(
            children: items.map((e) => SectionHeader(
              title: e.item1,
              child: e.item2,
            )).toList(),
          ),
        ),
      ],
    );
  }

  Widget buildButtonSmall() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FloatingActionButton.small(
          onPressed: (){

          },
          child: Icon(Icons.edit),
        ),
        SizedBox(height: 16,),
        FloatingActionButton.small(
          // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          // extendedPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8),),
          ),
          onPressed: (){

          },
          child: Container(
              // padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Text("Small (40)")
          ),
        ),
      ],
    );
  }

  Widget buildButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FloatingActionButton(
          onPressed: (){

          },
          child: Icon(Icons.edit),
        ),
        SizedBox(height: 16,),
        FloatingActionButton(
          // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          // extendedPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8),),
          ),
          onPressed: (){

          },
          child: Container(
            // padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Text("Regular (56)")
          ),
        ),
      ],
    );
  }

  Widget buildButtonLarge() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FloatingActionButton.large(
          onPressed: (){

          },
          child: Icon(Icons.edit),
        ),
        SizedBox(height: 16,),
        FloatingActionButton.large(
          // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          // extendedPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8),),
          ),
          onPressed: (){

          },
          child: Container(
            // padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Text("Large (96)")
          ),
        ),
      ],
    );
  }

  Widget buildButtonExtended() {
    return Column(
      children: [
        FloatingActionButton.extended(
          // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          // extendedPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8),),
          ),
          onPressed: (){

          },
          label: Text("Extended"),
        ),
        SizedBox(height: 16,),
        FloatingActionButton.extended(
          onPressed: (){

          },
          label: Text('Extended'),
          icon: Icon(Icons.edit),
        ),
      ],
    );
  }

  Widget buildButtonExtendedCustom() {
    return SizedBox(
      height: 30,
      child: FloatingActionButton.extended(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        extendedPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8),),
        ),
        onPressed: (){

        },
        label: Container(
          child: Text("发送"),
        ),
      ),
    );
  }

}