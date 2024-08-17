//
//
//
// import 'dart:collection';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
//
// class Item {
//   Item(this.price, this.count);
//   double price; //商品单价
//   int count; // 商品份数
// //... 省略其它属性
// }
//
// class CartModel extends ChangeNotifier {
//   // 用于保存购物车中商品列表
//   final List<Item> _items = [];
//
//   // 禁止改变购物车里的商品信息
//   UnmodifiableListView<Item> get items => UnmodifiableListView(_items);
//
//   // 购物车中商品的总价
//   double get totalPrice =>
//       _items.fold(0, (value, item) => value + item.count * item.price);
//
//   // 将 [item] 添加到购物车。这是唯一一种能从外部改变购物车的方法。
//   void add(Item item) {
//     _items.add(item);
//     // 通知监听器（订阅者），重新构建InheritedProvider， 更新状态。
//     notifyListeners();
//   }
// }
//
// class ProviderRoute extends StatefulWidget {
//   @override
//   _ProviderRouteState createState() => _ProviderRouteState();
// }
//
// class _ProviderRouteState extends State<ProviderRoute> {
//
//   // ValueNotifier<int> n;
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: ChangeNotifierProvider<CartModel>(
//         create: (context) => CartModel(),
//         child: Builder(builder: (context) {
//           return Column(
//             children: <Widget>[
//               Builder(builder: (context){
//                 var cart = ChangeNotifierProvider.of<CartModel>(context);
//                 return Text("总价: ${cart.totalPrice}");
//               }),
//               Builder(builder: (context){
//                 print("RaisedButton build"); //在后面优化部分会用到
//                 return RaisedButton(
//                   child: Text("添加商品"),
//                   onPressed: () {
//                     //给购物车中添加商品，添加后总价会更新
//                     ChangeNotifierProvider.of<CartModel>(context).add(Item(20.0, 1));
//                   },
//                 );
//               }),
//             ],
//           );
//         }),
//       ),
//     );
//   }
// }
//
//
// class ChangeNotifierProvider<T extends ChangeNotifier> extends StatefulWidget {
//   ChangeNotifierProvider({
//     Key? key,
//     this.data,
//     this.child,
//   });
//
//   final Widget child;
//   final T data;
//
//   //定义一个便捷方法，方便子树中的widget获取共享数据
//   static T of<T>(BuildContext context) {
//     final type = _typeOf<InheritedProvider<T>>();
//     final provider =  context.dependOnInheritedWidgetOfExactType<InheritedProvider<T>>();
//     return provider.data;
//   }
//
//   @override
//   _ChangeNotifierProviderState<T> createState() => _ChangeNotifierProviderState<T>();
// }
//
// class _ChangeNotifierProviderState<T extends ChangeNotifier> extends State<ChangeNotifierProvider<T>> {
//   void update() {
//     //如果数据发生变化（model类调用了notifyListeners），重新构建InheritedProvider
//     setState(() => {});
//   }
//
//   @override
//   void didUpdateWidget(ChangeNotifierProvider<T> oldWidget) {
//     //当Provider更新时，如果新旧数据不"=="，则解绑旧数据监听，同时添加新数据监听
//     if (widget.data != oldWidget.data) {
//       oldWidget.data.removeListener(update);
//       widget.data.addListener(update);
//     }
//     super.didUpdateWidget(oldWidget);
//   }
//
//   @override
//   void initState() {
//     // 给model添加监听器
//     widget.data.addListener(update);
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     // 移除model的监听器
//     widget.data.removeListener(update);
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return InheritedProvider<T>(
//       data: widget.data,
//       child: widget.child,
//     );
//   }
// }
