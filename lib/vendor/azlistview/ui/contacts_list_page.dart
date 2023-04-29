import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:azlistview/azlistview.dart';
import 'package:flutter_templet_project/extension/color_ext.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';
import 'package:flutter_templet_project/vendor/azlistview/common/index.dart';


class ContactListPage extends StatefulWidget {
  const ContactListPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  final List<ContactInfo> _contacts = [];
  double susItemHeight = 40;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    //加载联系人列表
    rootBundle.loadString('assets/data/contacts.json').then((value) {
      List list = json.decode(value);
      list.forEach((v) {
        _contacts.add(ContactInfo.fromJson(v));
      });
      _handleList(_contacts);
    });
  }

  void _handleList(List<ContactInfo> list) {
    if (list.isEmpty) return;
    for (int i = 0, length = list.length; i < length; i++) {
      String pinyin = PinyinHelper.getPinyinE(list[i].name);
      String tag = pinyin.substring(0, 1).toUpperCase();
      list[i].namePinyin = pinyin;
      if (RegExp("[A-Z]").hasMatch(tag)) {
        list[i].tagIndex = tag;
      } else {
        list[i].tagIndex = "#";
      }
    }
    // A-Z sort.
    // SuspensionUtil.sortListBySuspensionTag(_contacts);

    // show sus tag.
    SuspensionUtil.setShowSuspensionStatus(_contacts);

    // add header.
    // _contacts.insert(0, ContactInfo(name: 'header', tagIndex: '↑'));

    setState(() {});
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ClipOval(
              child: Image.asset(
            "./assets/images/avatar.png",
            width: 80.0,
          )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "远行",
              textScaleFactor: 1.2,
            ),
          ),
          Text("+86 182-286-44678"),
        ],
      ),
    );
  }

  Widget _buildSusWidget(String susTag) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      height: susItemHeight,
      width: double.infinity,
      alignment: Alignment.centerLeft,
      color: Colors.red,
      child: Row(
        children: <Widget>[
          Text(
            '$susTag',
            textScaleFactor: 1.2,
          ),
          Expanded(
              child: Divider(
            height: .0,
            indent: 10.0,
          ))
        ],
      ),
    );
  }

  Widget _buildListItem(ContactInfo model) {
    String susTag = model.getSuspensionTag();
    debugPrint("_buildListItem:${model.name}_${model.isShowSuspension}");
    return Container(
      height: 90,
      child: Column(
        children: <Widget>[
          // Offstage(
          //   offstage: model.isShowSuspension != true,
          //   child: _buildSusWidget(susTag),
          // ).toColoredBox(),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue[700],
              child: Text(
                model.name[0],
                style: TextStyle(color: Colors.white),
              ),
            ),
            title: Text(model.name),
            onTap: () {
              debugPrint("OnItemClick: $model");
              Navigator.pop(context, model);
            },
          )
        ],
      ),
    );
  }

  Decoration getIndexBarDecoration(Color color) {
    return BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: Colors.grey[300]!, width: .5));
  }

  @override
  Widget build(BuildContext context) {
    return AzListView(
      physics: AlwaysScrollableScrollPhysics(),
      data: _contacts,
      itemCount: _contacts.length,
      itemBuilder: (BuildContext context, int index) {
        // if (index == 0) return _buildHeader();
        ContactInfo model = _contacts[index];
        return _buildListItem(model);
      },
      susItemBuilder: (BuildContext context, int index) {
        ContactInfo model = _contacts[index];
        final str = "section${model.getSuspensionTag()}";
        return Container(
          height: 40,
          padding: EdgeInsets.only(left: 30),
          width: double.maxFinite,
          color: Colors.grey,
          child: Row(
            children: [
              Text(str),
            ],
          ),
        );
      },
      indexBarData: SuspensionUtil.getTagIndexList(_contacts),
      indexHintBuilder: (context, hint) {
        return Container(
          alignment: Alignment.center,
          width: 60.0,
          height: 60.0,
          decoration: BoxDecoration(
            color: Colors.blue[700]!.withAlpha(200),
            shape: BoxShape.circle,
          ),
          child:
              Text(hint, style: TextStyle(color: Colors.red, fontSize: 30.0)),
        );
      },
      indexBarMargin: EdgeInsets.all(10),
      indexBarOptions: IndexBarOptions(
        needRebuild: true,
        decoration: getIndexBarDecoration(Colors.grey[50]!),
        downDecoration: getIndexBarDecoration(Colors.grey[200]!),
      ),
    );
  }
}
