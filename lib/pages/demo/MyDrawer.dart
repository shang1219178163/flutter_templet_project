

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///左侧抽屉菜单
class MyDrawer extends StatelessWidget {
  const MyDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: MediaQuery.removePadding(
        context: context,
        //移除抽屉菜单顶部默认留白
        removeTop: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 38.0),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: ClipOval(
                      // child: Image.asset(
                      //   "images/avatar.png",
                      //   width: 80,
                      // ),
                      child: FlutterLogo(size: 60,),
                    ),
                  ),
                  Text(
                    "Wendux",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.add),
                    title: Text('Add account'),
                    trailing: Icon(Icons.add_a_photo),
                    onTap: (){
                      debugPrint('Add account');
                    },
                  ),
                  Divider(
                    indent: 15,
                    endIndent: 15,
                    height: 1,
                    color: Colors.grey,
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Manage accounts'),
                    onTap: (){
                      debugPrint("${Icons.title}");
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text(
                      "Your Profile",
                    ),
                    onTap: (){
                      debugPrint("Tapped Profile");
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}