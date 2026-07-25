import 'package:flutter/material.dart';
import 'package:flutter_templet_project/mixin/chewie_player_mixin.dart';
import 'package:flutter_templet_project/pages/demo/html_render/model/article_detail_model.dart';

///足球赛事-资讯Provider
class ArticleDetailProvider extends ChangeNotifier with ChewiePlayerMixin {
  ArticleDetailModel? _detail;
  ArticleDetailModel? get detail => _detail;
}
