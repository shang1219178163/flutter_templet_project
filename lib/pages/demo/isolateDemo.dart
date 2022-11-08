import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/intl_extension.dart';

class IsolateDemo extends StatefulWidget {

  final String? title;

  IsolateDemo({ Key? key, this.title}) : super(key: key);

  
  @override
  _IsolateDemoState createState() => _IsolateDemoState();
}

class _IsolateDemoState extends State<IsolateDemo> {

  var content = "点击计算按钮,开始计算";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Isolate"),
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return SafeArea(
      child: Center(
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 500,
              child: Text(content)
            ),
            TextButton(
              child: Text('计算'),
              onPressed: () async {
                //flutter中创建isolate---compute()方法, 函数只能是顶级函数
                num result = await compute(sum, 1000000);
                final fmtValue = int.parse('$result').numFormat('0,000.00');
                content = "计算结果$fmtValue";
                setState(() {});
              },
            )
          ],
        ),
      ),
    );
  }
}


//计算0到 num 数值的总和
int sum(int num) {
  int count = 0;
  while (num > 0) {
    count = count + num;
    num--;
  }
  return count;
}