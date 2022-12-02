

import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/APPThemeSettings.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/provider/color_filtered_provider.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class APPDrawerMenuPage extends StatefulWidget {

  final String? title;

  APPDrawerMenuPage({ Key? key, this.title}) : super(key: key);


  @override
  _APPDrawerMenuPageState createState() => _APPDrawerMenuPageState();
}

class _APPDrawerMenuPageState extends State<APPDrawerMenuPage> {

  bool isGrey = false;

  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;
    return buildDrawerMenu(context);
  }
  
  Drawer buildDrawerMenu(BuildContext context) {
    var filteredProvider = Provider.of<ColorFilteredProvider>(context);

    return
      Drawer(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero, //去掉顶部灰色部分
                children: <Widget>[
                  // UserAccountsDrawerHeader(
                  //     accountName: Text("accountName"),
                  //     accountEmail: Text("accountEmail"),
                  //     currentAccountPicture: FlutterLogo(),
                  // ),
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
                    textAlign: TextAlign.center,),
                  ListTile(
                    leading: Icon(Icons.person, color: Theme.of(context).accentColor),
                    // leading: Icon(Icons.person, color: Theme.of(context).iconTheme.color),
                    title: Text("我的", style: TextStyle(fontSize: 16.0)),
                    trailing: Icon(Icons.chevron_right),
                    dense: true,
                    // horizontalTitleGap: 0,
                    minLeadingWidth: 0,
                    minVerticalPadding: 0,
                    onTap: (){
                      Navigator.pop(context);
                      setState(() {
                        ddlog("我的");
                      });
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.volume_up, color: Theme.of(context).accentColor),
                    title: Text("消息",style: TextStyle(fontSize: 16.0)),
                    trailing: Icon(Icons.chevron_right),
                    dense: true,
                    // horizontalTitleGap: 0,
                    minLeadingWidth: 0,
                    minVerticalPadding: 0,
                    onTap: (){
                      Navigator.pop(context);
                      Get.toNamed('notice');
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.settings, color: Theme.of(context).accentColor),
                    title: Text("设置",style: TextStyle(fontSize: 16.0)),
                    trailing: Icon(Icons.chevron_right),
                    dense: true,
                    // horizontalTitleGap: 0,
                    minLeadingWidth: 0,
                    minVerticalPadding: 0,
                    onTap: (){
                      Navigator.pop(context);
                      Get.toNamed('setting');
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.share, color: Theme.of(context).accentColor),
                    title: Text("分享",style: TextStyle(fontSize: 16.0)),
                    trailing: Icon(Icons.chevron_right),
                    dense: true,
                    // horizontalTitleGap: 0,
                    minLeadingWidth: 0,
                    minVerticalPadding: 0,
                    onTap: (){
                      ddlog("分享");
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.open_in_new, color: Theme.of(context).accentColor),
                    title: Text("退出",style: TextStyle(fontSize: 16.0)),
                    trailing: Icon(Icons.chevron_right),
                    dense: true,
                    // horizontalTitleGap: 0,
                    minLeadingWidth: 0,
                    minVerticalPadding: 0,
                    onTap: (){
                      ddlog("退出");
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.change_circle_outlined, color: Theme.of(context).accentColor),
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
                  ),
                ],
              ),

              Row(children: [
                TextButton(onPressed: (){
                  setState(() {
                    APPThemeSettings.instance.changeTheme();
                  });
                }, child: Text("主题切换",
                  style: TextStyle(color: Theme.of(context).accentColor),
                  )
                ),
                
                TextButton(onPressed: (){
                  APPThemeSettings.instance.showThemePicker(context: context, callback: (){
                    Navigator.of(context).pop();
                  });
                }, child: Text("light主题切换",
                  style: TextStyle(color: Theme.of(context).accentColor),
                  )
                ),
              ],
              ),
              SizedBox(height: 15,)
            ],
          ),
        ),
      );
  }
}