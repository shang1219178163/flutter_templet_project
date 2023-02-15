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

class _MaterialDemoState extends State<MaterialDemo> {


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
          onPressed: () => print(e),)
        ).toList(),
      ),
      body: _buildMaterialDemo()
    );
  }

  _buildMaterialDemo() {
    return Center(
      child: Material(
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