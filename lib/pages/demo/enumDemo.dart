
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/NSectionHeader.dart';
import 'package:flutter_templet_project/enum/ActivityType.dart';


class EnumDemo extends StatefulWidget {

  EnumDemo({
    Key? key,
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _EnumDemoState createState() => _EnumDemoState();
}

class _EnumDemoState extends State<EnumDemo> {


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
          onPressed: () => debugPrint(e),)
        ).toList(),
      ),
      body: buildBody(),
    );
  }

  buildBody() {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NHeader.h4(title: "ActivityTypeNew",),
            NHeader.h5(title: "1.ActivityTypeNew.values"),
            Container(
              child: Text(ActivityTypeNew.values.toString()),
            ),
            Divider(),
            NHeader.h5(title: "2. ActivityTypeNew.values.map((e) => e.name)"),
            Container(
              child: Text("${ActivityTypeNew.values.map((e) => e.name)}"),
            ),
            Divider(),
          ],
        ),
        Column(
          children: [
            NHeader.h4(title: "ActivityType",),
            Container(
              child: Text("${ActivityType.values.map((e) => e.name)}"),
            ),
            Container(
              child: Text("${ActivityType.values}"),
            ),
          ],
        ),
        Expanded(
          child: ListView(
            children: ActivityType.values.map((e){

              return ListTile(
                title: Text(e.name),
                subtitle: Text("value:${e.value}, ${e.desc}, index:${e.index}"),
              );
            }).toList(),
          )
        )
      ],
    );
  }
}



