import 'package:flutter/material.dart';
import 'package:flutter_templet_project/APPThemeSettings.dart';
import 'package:flutter_templet_project/basicWidget/n_section_box.dart';
import 'package:flutter_templet_project/extension/decoration_ext.dart';

class FourthPage extends StatelessWidget {
  const FourthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$this"),
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return ListView(
      children: [
        Column(
          children: [
            NSectionBox(
              title: "_buildOrderCell",
              child: IntrinsicHeight(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      // width: 100,
                      color: Colors.green,
                      child: Column(children: [
                        Text("07-08"),
                        Text("13:20"),
                      ]),
                    ),
                    // _buildTimeLineIndicator(0),
                    Icon(Icons.add_circle, color: Colors.green),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "新建工单",
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.w500),
                              maxLines: 2,
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              "备注：降价1000客户可考虑，辛苦再撮合;备注：降价1000客户可考虑，辛苦再撮合备注：降价1000客户可考虑",
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            NSectionBox(
              title: "设置文字 3D效果",
              child: IntrinsicHeight(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Text(
                        'Hello, world!',
                        style: TextStyle(
                          fontSize: 42,
                          color: Colors.pink,
                          fontWeight: FontWeight.w900,
                          shadows: shadow3D,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
