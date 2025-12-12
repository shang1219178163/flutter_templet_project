import 'dart:convert';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_templet_project/mixin/chewie_player_mixin.dart';
import 'package:flutter_templet_project/pages/demo/html_render/model/NewsDetailModel.dart';
import 'package:flutter_templet_project/pages/demo/html_render/model/NewsRelevantMatch.dart';
import 'package:flutter_templet_project/pages/demo/html_render/model/NewsDetailModel.dart';

///足球赛事-资讯Provider
class NewsDetailProvider extends ChangeNotifier with ChewiePlayerMixin {
  NewsDetailModel? _detail;
  NewsDetailModel? get detail => _detail;
}
