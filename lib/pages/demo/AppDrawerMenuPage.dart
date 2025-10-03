import 'package:flutter/material.dart';

import 'package:flutter_templet_project/AppThemeService.dart';
import 'package:flutter_templet_project/cache/cache_service.dart';
import 'package:flutter_templet_project/extension/dlog.dart';
import 'package:flutter_templet_project/extension/route_ext.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/model/cell_model.dart';
import 'package:flutter_templet_project/provider/color_filtered_provider.dart';
import 'package:flutter_templet_project/routes/APPRouter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AppDrawerMenuPage extends StatefulWidget {
  const AppDrawerMenuPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _AppDrawerMenuPageState createState() => _AppDrawerMenuPageState();
}

class _AppDrawerMenuPageState extends State<AppDrawerMenuPage> {
  final items = <CellModel>[
    CellModel(icon: Icons.person, title: "我的"),
    CellModel(icon: Icons.open_in_new, title: "退出"),
    CellModel(icon: Icons.color_lens_outlined, title: "主题色", arguments: {
      "name": APPRouter.themeColorDemo,
    }),
    CellModel(icon: Icons.terminal, title: "本地日志", arguments: {
      "name": APPRouter.jPushInfoPage,
    }),
    CellModel(
      icon: Icons.recycling,
      title: "记录路由",
      isOpen: CacheService().getBool(CacheKey.resetLastPageRoute.name) ?? false,
    ),
  ];

  bool isGrey = false;

  get textStyle => TextStyle(color: Theme.of(context).primaryColor);

  get themeTitle => Get.isDarkMode ? "默认主题" : "暗黑主题";

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
                ...items.map((e) {
                  if (e.isOpen != null) {
                    return Column(
                      children: [
                        StatefulBuilder(
                          builder: (BuildContext context, StateSetter setState) {
                            final open = e.isOpen ?? false;
                            return ListTile(
                              dense: false,
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              leading: Icon(e.icon),
                              title: Text(e.title, style: TextStyle(fontSize: 16.0)),
                              trailing: Switch(
                                onChanged: (bool value) {
                                  e.isOpen = !open;
                                  setState(() {});
                                  CacheService().setBool(CacheKey.resetLastPageRoute.name, e.isOpen);
                                  DLog.d(
                                      "resetLastPageRoute: ${CacheService().getBool(CacheKey.resetLastPageRoute.name)}");
                                },
                                value: open,
                              ),
                              // horizontalTitleGap: 0,
                              minLeadingWidth: 0,
                              minVerticalPadding: 0,
                              onTap: () {
                                DLog.d("退出");
                              },
                            );
                          },
                        ),
                        Divider(height: 1),
                      ],
                    );
                  }
                  return Column(
                    children: [
                      ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        leading: Icon(e.icon),
                        title: Text(e.title, style: TextStyle(fontSize: 16.0)),
                        trailing: Icon(Icons.chevron_right),
                        // horizontalTitleGap: 0,
                        minLeadingWidth: 0,
                        minVerticalPadding: 0,
                        onTap: () {
                          Navigator.pop(context);

                          final name = e.arguments?["name"] as String? ?? "";
                          Get.toNamed(name,
                              arguments: RouteSettings(
                                name: name,
                                arguments: {
                                  "name": name,
                                  "args": "args",
                                },
                              ).toJson());
                        },
                      ),
                      Divider(height: 1),
                    ],
                  );
                }).toList(),
                buildGrayMode(),
                Divider(height: 1),
              ],
            ),
            Column(
              children: [
                SizedBox(height: 12),
                ...buildFooter(),
              ],
            )
          ],
        ),
      ),
    );
  }

  List<Widget> buildHeader() {
    return [
      DrawerHeader(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
          // image: DecorationImage(
          //   image: "img_flutter_3_10.webp".toAssetImage(),
          // ),
        ),
        child: UnconstrainedBox(
          //解除父级的大小限制
          child: CircleAvatar(
            radius: 48,
            backgroundImage: 'avatar.png'.toAssetImage(),
          ),
        ),
      ),
      Text(
        '设置在主页面,否则底部按钮无法挡住!',
        style: TextStyle(
          fontSize: 12.0,
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
            onPressed: () {
              AppThemeService().changeTheme();
              setState(() {});
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.change_circle_outlined),
                SizedBox(width: 3),
                Text(themeTitle),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: () {
              AppThemeService().showSeedColorPicker(
                context: context,
              );
            },
            icon: Icon(Icons.color_lens),
            label: Text(
              "Light主题切换",
            ),
          ),
        ],
      ),
    ];
  }

  buildGrayMode() {
    var filteredProvider = Provider.of<ColorFilteredProvider>(context);
    return ListTile(
      dense: false,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Icon(
        Icons.change_circle_outlined,
      ),
      title: Text("灰色滤镜", style: TextStyle(fontSize: 16.0)),
      trailing: Switch(
        onChanged: (bool value) {
          isGrey = !isGrey;
          debugPrint("isGrey:$isGrey");
          final color = value ? Colors.grey : Colors.transparent;
          filteredProvider.setColor(color);
        },
        value: isGrey,
      ),
      // horizontalTitleGap: 0,
      minLeadingWidth: 0,
      minVerticalPadding: 0,
      onTap: () {
        DLog.d("退出");
      },
    );
  }
}
