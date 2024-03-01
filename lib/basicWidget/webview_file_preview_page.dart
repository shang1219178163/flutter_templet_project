//
//  WebviewFilePreviewPage.dart
//  yl_health_app
//
//  Created by shang on 2023/9/19 16:24.
//  Copyright © 2023/9/19 shang. All rights reserved.
//


import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';


/// 网页加载
class WebviewFilePreviewPage extends StatefulWidget {

  WebviewFilePreviewPage({
    Key? key,
    required this.url,
    this.title,
  }) : super(key: key);

  final String url;
  final String? title;

  @override
  _WebviewFilePreviewPageState createState() => _WebviewFilePreviewPageState();
}

class _WebviewFilePreviewPageState extends State<WebviewFilePreviewPage> {

  final  _progressVN = ValueNotifier(0.0);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? '详情'),
        actions: [
          IconButton(
            onPressed: (){

            },
            icon: Icon(Icons.save_alt, color: Colors.black87,)
          )
        ],
      ),
      body: Stack(
        children: [
          // WebView(
          //   initialUrl: widget.url,
          //   javascriptMode: JavascriptMode.unrestricted,
          //   onProgress: (int progress) {
          //     debugPrint("progress: $progress");
          //     _progressVN.value = progress/100;
          //   },
          //   onPageStarted: (String url) {
          //     debugPrint("onPageStarted $url");
          //   },
          //   onPageFinished: (String url) {
          //     debugPrint("onPageFinished $url");
          //     _progressVN.value = 1;
          //   },
          // ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: ValueListenableBuilder<double>(
             valueListenable: _progressVN,
             builder: (context, value, child){

               if (value < 0.12) {
                  return Center(
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator()
                    ),
                  );
                }
                return SizedBox();
              }
            ),
          ),
        ],
      ),
    );
  }
}
