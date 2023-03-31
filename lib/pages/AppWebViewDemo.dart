//
//  AppWebViewDemo.dart
//  flutter_templet_project
//
//  Created by shang on 6/8/21 8:54 AM.
//  Copyright © 6/8/21 shang. All rights reserved.
//

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:webview_flutter/webview_flutter.dart';


String kNavigationExamplePage = '''
<!DOCTYPE html><html>
<head><title>Navigation Delegate Example</title></head>
<body>
<p>
The navigation delegate is set to block navigation to the youtube website.
</p>
<ul>
<ul><a href="https://www.youtube.com/">https://www.youtube.com/</a></ul>
<ul><a href="https://www.google.com/">https://www.google.com/</a></ul>
</ul>
</body>
</html>
''';

class AppWebViewDemo extends StatefulWidget {
  @override
  _AppWebViewDemoState createState() => _AppWebViewDemoState();
}

class _AppWebViewDemoState extends State<AppWebViewDemo> {
  final Completer<WebViewController> _controller = Completer<WebViewController>();

  String _currentTitle = "";
  double _progress = 0;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentTitle, style: TextStyle(fontSize: 16,), textAlign: TextAlign.center,),
        leadingWidth: 100,
        leading: buildRight(context),
        actions: [
          buildRefresh(),
          SampleMenu(_controller.future),
        ],
      ),
      body: Builder(builder: (BuildContext context) {
        return Stack(
          children: [
            WebView(
              initialUrl: 'https://flutter.dev',
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
              onProgress: (int progress) {
                // ddlog("WebView is loading(progress: $progress%_${progress*0.01})");
                setState(() {
                  _progress = progress*0.01;
                });
                // ddlog(_progress);
              },
              javascriptChannels: <JavascriptChannel>{
                _toasterJavascriptChannel(context),
              },
              navigationDelegate: (NavigationRequest request) {
                if (request.url.startsWith('https://www.youtube.com/')) {
                  print('blocking navigation to $request}');
                  return NavigationDecision.prevent;
                }
                print('allowing navigation to $request');
                return NavigationDecision.navigate;
              },
              onPageStarted: (String url) {
                print('Page started loading: $url');
              },
              onPageFinished: (String url) {
                print('Page finished loading: $url');
                setState(() {
                  // (await controller.data!.currentUrl())!
                  _controller.future.then((value) => value.getTitle()).then((value) {
                    _currentTitle = value ?? "";
                  });
                });
              },
              gestureNavigationEnabled: true,
            ),

            LinearProgressIndicator(
              value: _progress,
              // semanticsLabel: 'Linear progress indicator',
              // semanticsValue: "sadfasdfsa",
              minHeight: 4,
              backgroundColor: Colors.transparent,
              color: _progress >= 1 ? Colors.transparent : Colors.blue,
            ),
          ],
        );
      }),
      floatingActionButton: favoriteButton(),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }

  Widget favoriteButton() {
    return FutureBuilder<WebViewController>(
        future: _controller.future,
        builder: (BuildContext context, AsyncSnapshot<WebViewController> controller) {
          if (controller.hasData) {
            return FloatingActionButton(
              onPressed: () async {
                final url = (await controller.data!.currentUrl())!;
                // ignore: deprecated_member_use
                Scaffold.of(context).showSnackBar(
                  SnackBar(content: Text('Favorited $url')),
                );
              },
              child: Icon(Icons.favorite),
            );
          }
          return Container();
        });
  }

  Widget buildRefresh() {
    return FutureBuilder<WebViewController>(
        future: _controller.future,
        builder: (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
          final webViewReady = snapshot.connectionState == ConnectionState.done;
          final controller = snapshot.data!;
          if (snapshot.hasData) {
            return IconButton(
              icon: const Icon(Icons.replay),
              onPressed: !webViewReady
                  ? null
                  : () {
                controller.reload();
              },
            );
          }
          return Container();
      }
    );
  }


  //
  Widget buildRight(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: _controller.future,
      builder: (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
        final webViewReady = snapshot.connectionState == ConnectionState.done;
        final controller = snapshot.data!;
        return Row(
          children: <Widget>[
            SizedBox(width: 10,),
            Expanded(child: 
              IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: !webViewReady ? null : () async {
                  if (await controller.canGoBack()) {
                    await controller.goBack();
                  } else {
                    Navigator.pop(context);
                    return;
                  }
                },
              ),
            ),
            Expanded(child: 
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

enum MenuOptions {
  showUserAgent,
  listCookies,
  clearCookies,
  addToCache,
  listCache,
  clearCache,
  navigationDelegate,
}

class SampleMenu extends StatelessWidget {
  SampleMenu(this.controller);

  final Future<WebViewController> controller;
  final CookieManager cookieManager = CookieManager();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: controller,
      builder: (BuildContext context, AsyncSnapshot<WebViewController> controller) {
        return PopupMenuButton<MenuOptions>(
          onSelected: (MenuOptions value) {
            switch (value) {
              case MenuOptions.showUserAgent:
                _onShowUserAgent(controller.data!, context);
                break;
              case MenuOptions.listCookies:
                _onListCookies(controller.data!, context);
                break;
              case MenuOptions.clearCookies:
                _onClearCookies(context);
                break;
              case MenuOptions.addToCache:
                _onAddToCache(controller.data!, context);
                break;
              case MenuOptions.listCache:
                _onListCache(controller.data!, context);
                break;
              case MenuOptions.clearCache:
                _onClearCache(controller.data!, context);
                break;
              case MenuOptions.navigationDelegate:
                _onNavigationDelegateExample(controller.data!, context);
                break;
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuItem<MenuOptions>>[
            PopupMenuItem<MenuOptions>(
              value: MenuOptions.showUserAgent,
              enabled: controller.hasData,
              child: Text('Show user agent'),
            ),
            PopupMenuItem<MenuOptions>(
              value: MenuOptions.listCookies,
              child: Text('List cookies'),
            ),
            PopupMenuItem<MenuOptions>(
              value: MenuOptions.clearCookies,
              child: Text('Clear cookies'),
            ),
            PopupMenuItem<MenuOptions>(
              value: MenuOptions.addToCache,
              child: Text('Add to cache'),
            ),
            PopupMenuItem<MenuOptions>(
              value: MenuOptions.listCache,
              child: Text('List cache'),
            ),
            PopupMenuItem<MenuOptions>(
              value: MenuOptions.clearCache,
              child: Text('Clear cache'),
            ),
            PopupMenuItem<MenuOptions>(
              value: MenuOptions.navigationDelegate,
              child: Text('Navigation Delegate example'),
            ),
          ],
        );
      },
    );
  }

  void _onShowUserAgent(WebViewController controller, BuildContext context) async {
    // Send a message with the user agent string to the Toaster JavaScript channel we registered
    // with the WebView.
    await controller.evaluateJavascript(
        'Toaster.postMessage("User Agent: " + navigator.userAgent);');
  }

  void _onListCookies(WebViewController controller, BuildContext context) async {
    final cookies = await controller.evaluateJavascript('document.cookie');
    // ignore: deprecated_member_use
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('Cookies:'),
          _getCookieList(cookies),
        ],
      ),
    ));
  }

  void _onAddToCache(WebViewController controller, BuildContext context) async {
    await controller.evaluateJavascript(
        'caches.open("test_caches_entry"); localStorage["test_localStorage"] = "dummy_entry";');
    // ignore: deprecated_member_use
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text('Added a test entry to cache.'),
    ));
  }

  void _onListCache(WebViewController controller, BuildContext context) async {
    await controller.evaluateJavascript('caches.keys()'
        '.then((cacheKeys) => JSON.stringify({"cacheKeys" : cacheKeys, "localStorage" : localStorage}))'
        '.then((caches) => Toaster.postMessage(caches))');
  }

  void _onClearCache(WebViewController controller, BuildContext context) async {
    await controller.clearCache();
    // ignore: deprecated_member_use
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("Cache cleared."),
    ));
  }

  void _onClearCookies(BuildContext context) async {
    final hadCookies = await cookieManager.clearCookies();
    var message = 'There were cookies. Now, they are gone!';
    if (!hadCookies) {
      message = 'There are no cookies.';
    }
    // ignore: deprecated_member_use
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  void _onNavigationDelegateExample(WebViewController controller, BuildContext context) async {
    final contentBase64 = base64Encode(Utf8Encoder().convert(kNavigationExamplePage));
    await controller.loadUrl('data:text/html;base64,$contentBase64');
  }

  Widget _getCookieList(String cookies) {
    if (cookies == null || cookies == '""') {
      return Container();
    }
    final cookieList = cookies.split(';');
    final cookieWidgets =
    cookieList.map((String cookie) => Text(cookie));
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: cookieWidgets.toList(),
    );
  }
}

class NavigationControls extends StatelessWidget {
  final Future<WebViewController> _webViewControllerFuture;

  const NavigationControls(this._webViewControllerFuture) : assert(_webViewControllerFuture != null);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: _webViewControllerFuture,
      builder: (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
        final webViewReady = snapshot.connectionState == ConnectionState.done;
        final controller = snapshot.data!;
        return Row(
          children: <Widget>[
            SizedBox(width: 10,),
            Expanded(child: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: !webViewReady ? null : () async {
                if (await controller.canGoBack()) {
                  await controller.goBack();
                } else {
                  // ignore: deprecated_member_use
                  Scaffold.of(context).showSnackBar(
                    SnackBar(content: Text("No back history item")),
                  );
                  return;
                }
              },)
            ),
            SizedBox(width: 30,),
            Expanded(child:
                SizedBox(
                  width: 44,
                  height: 44,
                  child: IconButton(
                  icon: Icon(Icons.arrow_forward_ios),
                  onPressed: !webViewReady ? null : () async {
                    if (await controller.canGoForward()) {
                      await controller.goForward();
                    } else {
                      // ignore: deprecated_member_use
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                            content: Text("No forward history item")),
                      );
                      return;
                    }
                  },
                ),
                )
            ),
            // SizedBox(width: 15,),
            // Expanded(child: IconButton(
            //   icon: Icon(Icons.replay),
            //   onPressed: !webViewReady ? null : () {
            //     controller.reload();
            //   },
            // )
            // ),
          ],
        );
      },
    );
  }
}