import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:tuple/tuple.dart';

class SmartDialogPageDemo extends StatelessWidget {
  const SmartDialogPageDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SmartDialogPage(),
      navigatorObservers: [FlutterSmartDialog.observer],
      builder: FlutterSmartDialog.init(),
    );
  }
}

class SmartDialogPage extends StatelessWidget {
  const SmartDialogPage({Key? key}) : super(key: key);

  List<Tuple2> get items => [
    Tuple2('showToast', _showToast()),
    Tuple2('showLoading', _showLoading()),
    Tuple2('_show', _show()),
    Tuple2('_showAttach', _showAttach()),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('SmartDialog-EasyDemo')),
      body: Container(
        margin: EdgeInsets.all(30),
        child: Wrap(spacing: 20,
            children: items.map((e) => ElevatedButton(
              onPressed: () => e.item2,
              child: Text(e.item1),
            )).toList()
        ),
      ),
    );
  }


  _showToast() {
    // SmartDialog.showToast('test toast11', alignment: Alignment.topCenter);
    SmartDialog.showToast('the toast at the center', alignment: Alignment.center);
    SmartDialog.showToast('the toast at the bottomCenter', alignment: Alignment.bottomCenter);

    debugPrint('SmartDialog.showToast');
  }

  _show() async {
    SmartDialog.show(
        maskColor: Colors.transparent,
        animationType: SmartAnimationType.fade,
        builder: (_) {
          return Container(
            // margin:const EdgeInsets.only(left: 16, right: 16, top: 56, bottom: 56,),
            // padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12,),
            height: 50,
            width: 200,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(
              'easy custom dialog',
              style: TextStyle(color: Colors.white),
            ),
          );
    });

    await Future.delayed(Duration(milliseconds: 1500));
    SmartDialog.dismiss();
  }

  _showAttach() {
    //target widget
    SmartDialog.show(
      useSystem: true,
      builder: (_) {
        return Container(
          height: 300,
          width: 500,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          alignment: Alignment.center,
          child: Builder(builder: (context) {
            return ElevatedButton(
              onPressed: () => attachDialog(context),
              child: Text('target widget'),
            );
          }),
        );
      },
    );
  }

  attachDialog(BuildContext context) {
    return SmartDialog.showAttach(
      targetContext: context,
      alignment: Alignment.bottomCenter,
      animationType: SmartAnimationType.scale,
      scalePointBuilder: (selfSize) => Offset(selfSize.width, 0),
      builder: (_) {
        return Container(height: 50, width: 30, color: Colors.red);
      },
    );
  }

  _bindPage(BuildContext ctx) {
    //target widget
    SmartDialog.show(
      bindPage: true,
      builder: (_) {
        return Container(
          height: 300,
          width: 500,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          alignment: Alignment.center,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(ctx, MaterialPageRoute(builder: (_) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text("New Page"),
                  ),
                  body: Center(child: Text("New Page")),
                );
              }));
            },
            child: Text('to new page'),
          ),
        );
      },
    );
  }

  _showLoading() async {
    SmartDialog.showLoading();
    await Future.delayed(Duration(seconds: 2));
    SmartDialog.dismiss();
  }
}
