//
//  BannerDemo.dart
//  flutter_templet_project
//
//  Created by shang on 10/28/21 5:34 PM.
//  Copyright © 10/28/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';

class BannerDemo extends StatefulWidget {

  const BannerDemo({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _BannerDemoState createState() => _BannerDemoState();
}

class _BannerDemoState extends State<BannerDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Banner Example"),
      ),
      body: Column(
        children: [
          buildBody(),
        ],
      ),
    );
  }

  Widget buildBody() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Align(
        alignment: Alignment.topCenter,
        child: Banner(
          message: 'Offer 20% off',
          location: BannerLocation.topEnd,
          color: Colors.red,
          child: Container(
            color: Colors.green,
            height: 186,
            width: 280,
            child: Image.network(
              'https://fastly.jsdelivr.net/npm/@vant/assets/apple-1.jpeg',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
