import 'package:flutter/material.dart';

class MaterialBannerDemo extends StatefulWidget {
  final String? title;

  const MaterialBannerDemo({Key? key, this.title}) : super(key: key);

  @override
  _MaterialBannerDemoState createState() => _MaterialBannerDemoState();
}

class _MaterialBannerDemoState extends State<MaterialBannerDemo> {
  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
        ),
        body: Column(children: [
          _buildMaterialBanner(),
        ]));
  }

  _buildMaterialBanner() {
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
