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
      child: FutureBuilder<Response<List<dynamic>>>(
          future: _dio.get<List<dynamic>>("https://api.github.com/orgs/flutterchina/repos"),
          builder: (BuildContext context, AsyncSnapshot<Response<List<dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              final response = snapshot.data;
              if (response == null) {
                return const Text('无数据');
              }
              final repos = response.data ?? <dynamic>[];
              return ListView(
                children: repos.map<Widget>((dynamic item) {
                  final repo = item as Map<String, dynamic>;
                  return ListTile(
                    title: Text('${repo['full_name'] ?? ''}'),
                    subtitle: Text('${repo['url'] ?? ''}'),
                  );
                }).toList(),
              );
            }
            return const CircularProgressIndicator();
          }),
    );
  }

  Widget _buildBodyByModel() {
    return Container(
      alignment: Alignment.center,
      child: FutureBuilder<Response<String>>(
          future: _dio.get<String>("https://api.github.com/orgs/flutterchina/repos"),
          builder: (BuildContext context, AsyncSnapshot<Response<String>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              final response = snapshot.data;
              if (response?.data == null) {
                return const Text('无数据');
              }
              final list = jsonDecode(response!.data!) as List<dynamic>;
              final models = list
                  .map<Repository>((dynamic item) => Repository.fromJson(item as Map<String, dynamic>))
                  .toList();
              return ListView(
                children: models
                    .map<Widget>((Repository e) => ListTile(
                          title: Text(e.name ?? "_"),
                          subtitle: Text(e.url ?? "_"),
                        ))
                    .toList(),
              );
            }
            return const CircularProgressIndicator();
          }),
    );
  }

  Widget _buildBodyByModel1() {
    return Container(
      alignment: Alignment.center,
      child: FutureBuilder<Response<List<dynamic>>>(
          future: _dio.get<List<dynamic>>("https://api.github.com/orgs/flutterchina/repos"),
          builder: (BuildContext context, AsyncSnapshot<Response<List<dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              final response = snapshot.data;
              if (response?.data == null) {
                return const Text('无数据');
              }
              final data = response!.data ?? <dynamic>[];
              final models = data
                  .map<Repository>((dynamic item) => Repository.fromJson(item as Map<String, dynamic>))
                  .toList();
              return ListView(
                children: models
                    .map<Widget>((Repository e) => ListTile(
                          title: Text(e.name ?? "_"),
                          subtitle: Text(e.url ?? "_"),
                        ))
                    .toList(),
              );
            }
            return const CircularProgressIndicator();
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
