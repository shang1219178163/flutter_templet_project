//
//  GithubRepoDemo.dart
//  flutter_templet_project
//
//  Created by shang on 7/26/21 5:56 PM.
//  Copyright © 7/26/21 shang. All rights reserved.
//

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/model/repo_model.dart';
import 'package:flutter_templet_project/model/repository.dart';
import 'package:flutter_templet_project/network/RequestManager.dart';
import 'package:flutter_templet_project/network/base_request_api.dart';
import 'package:json_annotation/json_annotation.dart';

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
    // TODO: implement initState
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
                // ddlog(model);
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
              Response response = snapshot.data;
              //发生错误
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              //请求成功，通过项目信息构建用于显示项目名称的ListView
              return ListView(
                children: response.data
                    .map<Widget>((e) => ListTile(
                          title: Text(e["full_name"]),
                          subtitle: Text(e["url"]),
                        ))
                    .toList(),
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
          future: _dio
              .get<String>("https://api.github.com/orgs/flutterchina/repos"),
          // future: RequestClient.get("https://api.github.com/orgs/flutterchina/repos"),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            //请求完成
            if (snapshot.connectionState == ConnectionState.done) {
              Response response = snapshot.data;
              //发生错误
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }

              ///字符串转json
              List<dynamic> list = jsonDecode(response.data);

              ///json转模型
              var models =
                  list.map<Repository>((e) => Repository.fromJson(e)).toList();

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
              Response response = snapshot.data;
              //发生错误
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }

              ///字符串转json
              // List<dynamic> list = jsonDecode(response.data);
              ///json转模型
              List<Repository> models = response.data
                  .map<Repository>((e) => Repository.fromJson(e))
                  .toList();

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

    var response =
        await _dio.get("https://api.github.com/orgs/flutterchina/repos");
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
