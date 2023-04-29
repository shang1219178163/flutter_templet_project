//
//  FutureBuilderDemo.dart
//  flutter_templet_project
//
//  Created by shang on 10/19/21 9:31 PM.
//  Copyright © 10/19/21 shang. All rights reserved.
//

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/model/git_repo_model.dart';
import 'package:flutter_templet_project/model/user_model.dart';


class FutureBuilderDemo extends StatefulWidget {

  final String? title;

  const FutureBuilderDemo({ Key? key, this.title}) : super(key: key);

  
  @override
  _FutureBuilderDemoState createState() => _FutureBuilderDemoState();
}

class _FutureBuilderDemoState extends State<FutureBuilderDemo> {

  final _dio = Dio();

  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          onPressed: onPressed,
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),)
        ).toList(),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Center(
      child: FutureBuilder<String>(
        future: mockNetworkData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          // 请求已结束
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              // 请求失败，显示错误
              return Text("Error: ${snapshot.error}");
            } else {
              // 请求成功，显示数据
              return Text("Contents: ${snapshot.data}");
            }
          } else {
            // 请求未结束，显示loading
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }

  Future<String> mockNetworkData() async {
    return Future.delayed(Duration(seconds: 2), () => "我是从互联网上获取的数据");
  }

  onPressed() async {
    // _dio.get("https://api.github.com/orgs/flutterchina/repos")
    //     .then((response) => response.json())
    //     .then((json) => json.json());

    var url = "https://api.github.com/orgs/flutterchina/repos";
    url = "https://api.github.com/users/shang1219178163/repos";
    // url = "https://jsonplaceholder.typicode.com/users";
    final response = await _dio.get<List<dynamic>>(url,);
    var items = (response.data ?? []).map((e) => GitRepoModel.fromJson(e)).toList();
    debugPrint("users: ${items.first.runtimeType}");

    testUrl();
  }

  testUrl() async {
    var url = "https://api.github.com/orgs/flutterchina/repos";
    final response = await _dio.get<List<dynamic>>(url,);
    final jsonStr = jsonEncode(response);
    debugPrint("${jsonStr}");
    final list = jsonDecode(jsonStr);
    debugPrint("list:${list.runtimeType.toString()}");

    // debugPrint("list: ${response.data.runtimeType.toString()}");
    // List<dynamic>? users = response.data;

    // var users = (response.data ?? []).map((e) => UserModel.fromJson(e)).toList();
    // debugPrint("users: ${users.first.runtimeType}");
  }
}