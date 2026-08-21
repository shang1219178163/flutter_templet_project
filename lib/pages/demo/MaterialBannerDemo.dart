import 'package:flutter/material.dart';

class MaterialBannerDemo extends StatefulWidget {

  const MaterialBannerDemo({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _MaterialBannerDemoState createState() => _MaterialBannerDemoState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('title', title));
  }
}

class _MaterialBannerDemoState extends State<MaterialBannerDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
        ),
        body: Column(children: [
          buildMaterialBanner(),
        ]));
  }

  Widget buildMaterialBanner() {
    return MaterialBanner(
      content: Text('Your account has been deleted.'),
      leading: CircleAvatar(
        child: Icon(Icons.account_box),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            debugPrint('NO');
          },
          child: Text('NO'),
        ),
        TextButton(
          onPressed: () {
            debugPrint('YES');
          },
          child: Text('YES'),
        ),
      ],
    );
  }
}
