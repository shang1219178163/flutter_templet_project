import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_templet_project/basicWidget/section_header.dart';

class DottedBorderDemo extends StatefulWidget {

  const DottedBorderDemo({ Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _DottedBorderDemoState createState() => _DottedBorderDemoState();
}

class _DottedBorderDemoState extends State<DottedBorderDemo> {



  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
          actions: ['done',].map((e) => TextButton(
            onPressed: () => debugPrint(e),
            child: Text(e,
              style: TextStyle(color: Colors.white),
            ),)
          ).toList(),
        ),
      body: Center(
        child: buildListView(),
      ),
    );
  }

  final GlobalKey _globalKey = GlobalKey();
  final GlobalKey _globalKey1 = GlobalKey();

  buildListView() {
    return ListView(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SectionHeader.h5(title: "DottedBorder"),
            Container(
              height: 100,
              // margin: EdgeInsets.all(20),
              // padding: EdgeInsets.all(20),
              child: DottedBorder(
                color: Colors.black,//color of dotted/dash line
                strokeWidth: 3, //thickness of dash/dots
                dashPattern: [10,0],
                //dash patterns, 10 is dash width, 6 is space width
                child: Container(  //inner container
                  margin: EdgeInsets.all(10),
                  color: Colors.green,
                ),
              )
            ),

            SectionHeader.h5(title: "DottedBorder"),
            Container(
              height: 100,
              // padding: EdgeInsets.all(20),
              child: DottedBorder(
                color: Colors.black,//color of dotted/dash line
                strokeWidth: 3, //thickness of dash/dots
                // dashPattern: [10, 6],
                //dash patterns, 10 is dash width, 6 is space width
                child: Container(  //inner container
                  color: Colors.green,
                ),
              )
            ),

            SectionHeader.h5(title: "DottedBorder"),
            Container(
              height: 100,
              // padding: EdgeInsets.all(20),
              child: DottedBorder(
                color: Colors.black,//color of dotted/dash line
                strokeWidth: 3, //thickness of dash/dots
                dashPattern: [10, 6],
                //dash patterns, 10 is dash width, 6 is space width
                child: Container(  //inner container
                  color: Colors.green,
                ),
              )
            ),
            Divider(),
            Container(
                height: 30,
                // padding: EdgeInsets.all(20),
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: Radius.circular(22),
                  padding: EdgeInsets.all(0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(22)),
                    child: Container(
                      height: 30,
                      width: 120,
                      color: Colors.amber,
                    ),
                  ),
                )
            ),
          ],
        ),
      ],
    );
  }

  _buildBody() {
    return Container(
        padding: EdgeInsets.all(20), //padding of outer Container
        child: DottedBorder(
          color: Colors.black,//color of dotted/dash line
          strokeWidth: 3, //thickness of dash/dots
          dashPattern: [10,6],
          //dash patterns, 10 is dash width, 6 is space width
          child: Container(  //inner container
              height:180, //height of inner container
              width: double.infinity, //width to 100% match to parent container.
              color:Colors.yellow //background color of inner container
          ),
        )
    );
  }
}