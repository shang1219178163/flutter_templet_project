//
//  GithubRepoDemo.dart
//  flutter_templet_project
//
//  Created by shang on 7/26/21 5:56 PM.
//  Copyright © 7/26/21 shang. All rights reserved.
//

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/model/repository.dart';
import 'package:flutter_templet_project/network/RequestManager.dart';
import 'package:flutter_templet_project/network/base_request_api.dart';

class GithubRepoDemo extends StatefulWidget {
  final String? title;

  const GithubRepoDemo({Key? key, this.title}) : super(key: key);

  @override
  _GithubRepoDemoState createState() => _GithubRepoDemoState();
}

class _GithubRepoDemoState extends State<GithubRepoDemo> {
  final Dio _dio = Dio();

  bool _isModel = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$widget"),
        actions: [
          IconButton(
              onPressed: () {
                // setState(() { });
                requestRepos();

                // final map = {
                // 'admin': true,
                // 'maintain': true,
                // 'push': true,
                // 'triage': false,
                // 'pull': false,
                // };
                // final model = Permissions.fromJson(map);
                // DLog.d(model);
              },
              icon: Icon(Icons.refresh)),
          TextButton(
              onPressed: () {
                setState(() {});
                _isModel = !_isModel;
              },
              child: Text(
                _isModel ? "model" : "json",
                style: TextStyle(color: Colors.white),
              )),
        ],
      ),
      body: _isModel ? _buildBodyByModel() : buildBody(),
      // body: _isModel ? _buildBodyByModel1() : buildBody(),
    );
  }

  Widget buildBody() {
    return Container(
      alignment: Alignment.center,
      child: FutureBuilder(
          future: _dio.get("https://api.github.com/orgs/flutterchina/repos"),
          // future: RequestClient.get("https://api.github.com/orgs/flutterchina/repos"),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            //请求完成
            if (snapshot.connectionState == ConnectionState.done) {
              //发生错误
              if (snapshot.data == null || snapshot.hasError) {
                return Text(snapshot.error.toString());
              }

              final response = snapshot.data as Response<dynamic>;

              //请求成功，通过项目信息构建用于显示项目名称的ListView
              final data = response.data as List<dynamic>? ?? <dynamic>[];
              return ListView(
                children: data.map<Widget>((e) {
                  final map = Map<String, dynamic>.from(e);
                  final fullName = map["full_name"] as String;
                  final url = map["url"] as String;
                  return ListTile(
                    title: Text(fullName),
                    subtitle: Text(
                      url,
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  );
                }).toList(),
              );
            }
            //请求未完成时弹出loading
            return CircularProgressIndicator();
          }),
    );
  }

  Widget _buildBodyByModel() {
    return Container(
      alignment: Alignment.center,
      child: FutureBuilder(
          future: _dio.get<String>("https://api.github.com/orgs/flutterchina/repos"),
          // future: RequestClient.get("https://api.github.com/orgs/flutterchina/repos"),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            //请求完成
            if (snapshot.connectionState == ConnectionState.done) {
              final response = snapshot.data as Response<String>;
              //发生错误
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }

              ///字符串转json
              var list = jsonDecode(response.data ?? '') as List<dynamic>;

              ///json转模型
              var models = list.map<Repository>((e) => Repository.fromJson(e)).toList();

              ///界面显示
              return ListView(
                children: models
                    .map<Widget>((e) => ListTile(
                          title: Text(e.name ?? "_"),
                          subtitle: Text(e.url ?? "_"),
                        ))
                    .toList(),
              );
            }
            //请求未完成时弹出loading
            return CircularProgressIndicator();
          }),
    );
  }

  Widget _buildBodyByModel1() {
    return Container(
      alignment: Alignment.center,
      child: FutureBuilder(
          future: _dio.get("https://api.github.com/orgs/flutterchina/repos"),
          // future: RequestClient.get("https://api.github.com/orgs/flutterchina/repos"),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            //请求完成
            if (snapshot.connectionState == ConnectionState.done) {
              final response = snapshot.data as Response<dynamic>;
              //发生错误
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }

              ///字符串转json
              // List<dynamic> list = jsonDecode(response.data);
              ///json转模型
              final data = response.data as List<dynamic>? ?? <dynamic>[];
              var models = data.map<Repository>((e) => Repository.fromJson(e as Map<String, dynamic>)).toList();

              ///界面显示
              return ListView(
                children: models
                    .map<Widget>((e) => ListTile(
                          title: Text(e.name ?? "_"),
                          subtitle: Text(e.url ?? "_"),
                        ))
                    .toList(),
              );
            }
            //请求未完成时弹出loading
            return CircularProgressIndicator();
          }),
    );
  }

  requestRepos() async {
    final api = ReposAPI();
    debugPrint("api: ${api.toString()}");

    final map = await RequestManager().request(api);

    var response = await _dio.get("https://api.github.com/orgs/flutterchina/repos");
    debugPrint("requestRepos: ${response.data.toString()}");
  }
}

class ReposAPI extends BaseRequestAPI {
  @override
  String get requestURI => "https://api.github.com/orgs/flutterchina/repos";

  @override
  HttpMethod get requestType => HttpMethod.GET;

  // @override
  // parse(Map data) {
  //   // TODO: implement parse
  //   throw UnimplementedError();
  // }
}
