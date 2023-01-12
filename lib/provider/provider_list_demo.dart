//
//  provider_list_demo.dart
//  flutter_templet_project
//
//  Created by shang on 10/13/21 11:30 AM.
//  Copyright © 10/13/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/dash_line.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/extension/buildContext_ext.dart';

import 'package:flutter_templet_project/model/order_model.dart';
import 'package:tuple/tuple.dart';
import 'notifier_demo.dart';

class ProviderListDemo extends StatefulWidget {

  final String? title;

  ProviderListDemo({ Key? key, this.title}) : super(key: key);

  @override
  _ProviderListDemoState createState() => _ProviderListDemoState();
}

class _ProviderListDemoState extends State<ProviderListDemo> {
  /// ChangeNotifier
  static CartModel cartModel = CartModel();

  static CartModelNew cartModelNew = CartModelNew(<OrderModel>[]);

  /// ValueNotifier
  static ValueNotifierOrderModels orderModels = ValueNotifierOrderModels();
  // /// ValueNotifier
  // static ValueNotifierNum valueNotifierInt = ValueNotifierNum(initValue: 6, minValue: 0, maxValue: 9, block: (int minValue, int maxValue){
  //   ddlog("数值必须在${minValue} - ${maxValue} 之间");
  // });

  /// ValueNotifier
  static ValueNotifierNum valueNotifierInt = ValueNotifierNum(initValue: 6, minValue: 0, maxValue: 9, block:(num minValue, num maxValue){
    ddlog("数值必须在${minValue} - ${maxValue} 之间");
  });

  static ValueNotifierNum valueNotifierDouble = ValueNotifierNum(initValue: 6, minValue: 0, maxValue: 9, block:(num minValue, num maxValue){
    ddlog("数值必须在${minValue} - ${maxValue} 之间");
  });
  // static ValueNotifierInt valueNotifierInt = ValueNotifierInt(initValue: 6, minValue: 0, maxValue: 9);

  ValueNotifier<int> notifier = ValueNotifier(3);

  /// ValueNotifier
  static ValueNotifierList valueNotifierList = ValueNotifierList(<OrderModel>[]);
  /// ValueNotifier(addListener无效 因为数组地址未发生改变, 推荐使用 ValueNotifierList)
  static ValueNotifier<List<OrderModel>> valueNotifierListOrigin = ValueNotifier(<OrderModel>[]);

  var counter = 3.notifier;

  Color get primaryColor => Theme.of(context).primaryColor;

  @override
  void initState() {
    super.initState();

    // valueNotifierInt.value = 6;
    // valueNotifierDouble.value = 9.9;

    valueNotifierInt.maxValue = 12;

    notifier.addListener(update);

    valueNotifierInt.addListener(update);
    valueNotifierDouble.addListener(update);

    orderModels.addListener(update);
    cartModelNew.addListener(update);

    valueNotifierList.addListener(update);
    valueNotifierListOrigin.addListener(update);
  }

  @override
  void dispose() {
    notifier.removeListener(update);

    valueNotifierInt.removeListener(update);
    valueNotifierDouble.removeListener(update);

    orderModels.removeListener(update);
    cartModelNew.removeListener(update);

    valueNotifierList.removeListener(update);
    valueNotifierListOrigin.removeListener(update);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
          actions: [
            IconButton(
              onPressed: (){
                updateChangeNotifier(model: cartModel, value: 1);
              },
              icon: Icon(Icons.add_circle_outline,)),
            IconButton(
              onPressed: (){
                updateChangeNotifier(model: cartModel, value: -1);
              },
              icon: Icon(Icons.remove_circle_outline,)),
          ],
        ),
        // body: Text("当前数量${cartCountKey.value}")
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                height: 100,
                color: Colors.green,
                child: Text("SliverToBoxAdapter"),
              ),
            ),
            buildSliverList(context),
            SliverToBoxAdapter(
              child: Container(
                height: 30,
                color: Colors.green,
                child: Align(
                  alignment: Alignment.centerLeft,
                    child: Text("SliverToBoxAdapter")),
              ),
            ),
            // buildListView(context),
          ],
        ),
    );
  }

  Widget buildSliverList(BuildContext context) {
    return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          return buildListCell(context, index);
        },
          childCount: list.length,
        )
    );
  }

  Widget buildListView(BuildContext context) {
    return SliverFillRemaining(
      child: ListView.separated(
        itemCount:list.length,
        //shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        //padding: EdgeInsets.all(0),
        separatorBuilder: (BuildContext context, int index){
          return Divider();
        },
        itemBuilder: (BuildContext context, int index) {
          //widget return
          return buildListCell(context, index);
        }),
    );
  }

  Widget buildListCell(BuildContext context, int index) {
    final e = list[index];
    return Column(
      children: [
        Container(
          height: 60,
          child: Row(
            children: [
              IconButton(
                onPressed: (){
                  handleActionNum(e: e, value: 1, idx: index);
                },
                icon: Icon(Icons.add_circle_outline, color: primaryColor,)
              ),
              IconButton(
                onPressed: (){
                  handleActionNum(e: e, value: -1, idx: index);
                },
                icon: Icon(Icons.remove_circle_outline, color: primaryColor,)
              ),
              // SizedBox(width: 8,),
              // Text("${e.name}当前值: ${e.notifier?.value}"),
              Expanded(
                child: Text("${e.notifier.toString()}",
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                )
              ),
              // Container(
              //   height: 50,
              //   child: Text("${e.notifier.toString()}", overflow: TextOverflow.ellipsis,),
              // )
              // Text("${e.notifier.toString()}", style: TextStyle(),),
              IconButton(
                onPressed: (){
                  handleActionNum(e: e, value: -1, idx: index);
                },
                icon: Icon(Icons.arrow_forward_ios, color: Colors.grey,)
              ),
            ],
          ),
        ),
        Divider(),
      ],
    );
  }

  void update() {
    showSnackBar(SnackBar(content: Text("数据变化监听回调, 刷新重建界面",)), true);
    // ddlog("数据变化监听回调, 刷新重建界面");
    setState(() {});
  }

  void handleActionNum({required ValueNotifierModel e, required int value, required int idx}) {
    switch (e.name) {
      case "valueNotifierIntKey":
        {
          valueNotifierInt.add(value);
          ddlog("${valueNotifierInt.value.toInt()}");
        }
        break;
      case "valueNotifierDoubleKey":
        {
          valueNotifierDouble.add(value);
          // ddlog(cartCountKey.toString());
          ddlog("${valueNotifierDouble.value.toDouble()}");
        }
        break;

      case "changeNotifierOrderModels":
        {
          final e = OrderModel(name: '商品', id: 99, pirce: 1.00);
          if (value > 0) {
            cartModel.add(e);
          } else {
            cartModel.removeLast();
          }

          ddlog(cartModel.toString());
          // ddlog("${cartModelKey.totalPrice}");
        }
        break;

      case "cartModelNew":
        {
          final e = OrderModel(name: '商品', id: 99, pirce: 1.00);
          if (value > 0) {
            cartModelNew.add(e);
          } else {
            cartModelNew.removeLast();
          }

          ddlog(cartModelNew.toString());
          ddlog(cartModelNew.totalPrice);

          // ddlog("${cartModelKey.totalPrice}");
        }
        break;
      case "valueNotifierOrderModels":
        {
          final e = OrderModel(name: '商品', id: 99, pirce: 1.00);
          if (value > 0) {
            orderModels.add(e);
          } else {
            orderModels.removeLast();
          }

          ddlog(orderModels.toString());
          // ddlog("${cartModelOneKey.totalPrice}");
        }
        break;
      case "valueNotifierList":
        {
          final e = OrderModel(name: '商品', id: 99, pirce: 1.00);
          if (value > 0) {
            valueNotifierList.add(e);
          } else {
            valueNotifierList.removeLast();
          }

          ddlog(valueNotifierList.toString());
          // ddlog("${cartModelOneKey.totalPrice}");
        }
        break;

      case "valueNotifierIntOrigin":
        {
          notifier.value += value;

          // ddlog(cartCountKey.toString());
          ddlog("${notifier.value}");
        }
        break;

      case "valueNotifierListOrigin":
        {
          final e = OrderModel(name: '商品', id: 99, pirce: 1.00);
          if (value > 0) {
            valueNotifierListOrigin.value.add(e);
          } else {
            valueNotifierListOrigin.value.removeLast();
          }

          update();///监听无效,需要手动调整

          ddlog(valueNotifierListOrigin.value.length.toString());
          // ddlog("${cartModelOneKey.totalPrice}");
        }
        break;
      default:
        break;
    }
  }

  void updateChangeNotifier({required CartModel model, required int value}) {
    final e = OrderModel(name: '商品', id: 99, pirce: 1.00);
    if (value > 0) {
      model.add(e);
    } else {
      model.removeLast();
    }

    update();
    ddlog(model.toString());

    if (value > 0) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('CartModel num\'s +1')));

    } else {
      showSnackBar(SnackBar(content: Text('CartModel num\'s -1')), true);
    }

  }

  var list = [
    ValueNotifierModel(name: "valueNotifierIntKey", notifier: valueNotifierInt),
    ValueNotifierModel(name: "valueNotifierDoubleKey", notifier: valueNotifierDouble),
    ValueNotifierModel(name: "valueNotifierOrderModels", notifier: orderModels),

    ValueNotifierModel(name: "cartModelNew", notifier: cartModelNew),

    ValueNotifierModel(name: "valueNotifierList", notifier: valueNotifierList),

    // ValueNotifierModel(name: "valueNotifierIntOrigin", notifier: valueNotifierIntOrigin),
    ValueNotifierModel(name: "valueNotifierListOrigin", notifier: valueNotifierListOrigin),

  ];

}



class ValueNotifierModel{

  String name = "";
  ValueNotifier? notifier;
  // ChangeNotifier? notifier;

  ValueNotifierModel({
    required this.name,
    required this.notifier,
  });

  ValueNotifierModel.fromJson(Map json){
    if(json.isEmpty){
      return;
    }
    notifier = json["notifier"];
    name = json["name"].stringValue;
  }

  Map<String, dynamic> toJson(){
    var json = Map<String, dynamic>();
    json["name"] = name;
    json["notifier"] = notifier;
    return json;
  }

}
