

import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/APPThemeSettings.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/provider/color_filtered_provider.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class APPDrawerMenuPage extends StatefulWidget {

  APPDrawerMenuPage({ Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _APPDrawerMenuPageState createState() => _APPDrawerMenuPageState();
}

class _APPDrawerMenuPageState extends State<APPDrawerMenuPage> {

  final items = <Tuple3<IconData, String, String>>[
    Tuple3(Icons.person, "我的", "mine"),
    Tuple3(Icons.volume_up, "消息", "notice"),
    Tuple3(Icons.settings, "设置", "setting"),
    Tuple3(Icons.share, "分享", "share"),
    Tuple3(Icons.open_in_new, "退出", "exit"),

  ];

  bool isGrey = false;

  get textStyle => TextStyle(color: Theme.of(context).primaryColor);

  get changeThemeTitle => Get.isDarkMode ? "默认主题" : "暗黑主题";

  @override
  Widget build(BuildContext context) {
    return buildDrawerMenu(context);
  }
  
  Drawer buildDrawerMenu(BuildContext context) {

    return Drawer(
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero, //去掉顶部灰色部分
              children: <Widget>[
                ...buildHeader(),
                ...items.map((e) => Column(
                  children: [
                    ListTile(
                      leading: Icon(e.item1, color: Theme.of(context).primaryColor),
                      title: Text(e.item2, style: TextStyle(fontSize: 16.0)),
                      trailing: Icon(Icons.chevron_right),
                      dense: true,
                      // horizontalTitleGap: 0,
                      minLeadingWidth: 0,
                      minVerticalPadding: 0,
                      onTap: (){
                        Navigator.pop(context);
                        Get.toNamed(e.item3);
                      },
                    ),
                    Divider(),
                  ],
                )).toList(),
                buildGrayRow(),
                Divider(),
              ],
            ),
            ...buildFooter(),
            // SizedBox(height: 15,)
          ],
        ),
      ),
    );
  }

  List<Widget> buildHeader() {
    return [
      DrawerHeader(
        decoration: BoxDecoration(color: Theme.of(context).primaryColor),
        child: UnconstrainedBox( //解除父级的大小限制
          child: CircleAvatar(
            radius: 48,
            // backgroundColor: Colors.transparent,
            backgroundImage: AssetImage('images/avatar.png')
          ),
        ),
      ),
      Text('设置在主页面,否则底部按钮无法挡住!',
        style: TextStyle(fontSize: 12.0,
          // color: Theme.of(context).primaryColor
        ),
        textAlign: TextAlign.center,
      ),
    ];
  }


  buildFooter() {
    return [
      Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
          onPressed: (){
            setState(() {
              APPThemeSettings.instance.changeTheme();
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.change_circle_outlined),
              SizedBox(width: 3,),
              Text(changeThemeTitle,)
            ],
          ),
        ),
        TextButton(
            onPressed: (){
              APPThemeSettings.instance.showThemePicker(
                  context: context,
                  callback: (){
                    Navigator.of(context).pop();
                  }
              );
            },
            child: Text("Light主题切换",)
        ),
      ],
    ),
    ];
  }

  buildGrayRow() {
    var filteredProvider = Provider.of<ColorFilteredProvider>(context);

    return ListTile(
      leading: Icon(Icons.change_circle_outlined, color: Theme.of(context).primaryColor),
      title: Text("灰色滤镜",style: TextStyle(fontSize: 16.0)),
      trailing: Switch(
        onChanged: (bool value) {
          isGrey = !isGrey;
          print("isGrey:${isGrey}");
          final color = value ? Colors.grey : Colors.transparent;
          filteredProvider.setColor(color);
        },
        value: isGrey,
      ),
      dense: true,
      // horizontalTitleGap: 0,
      minLeadingWidth: 0,
      minVerticalPadding: 0,
      onTap: (){
        ddlog("退出");
      },
    );
  }
}