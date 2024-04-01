//
//  data_provider.dart
//  flutter_templet_project
//
//  Created by shang on 2024/4/1 15:52.
//  Copyright © 2024/4/1 shang. All rights reserved.
//

/// 依赖倒置原则 (DIP)
/// 依赖倒置原则强调高层模块不应该依赖低层模块，两者都应该依赖抽象。
///

/// 抽象模块
abstract class DataFetcher {
  Future<Map<String, dynamic>?> fetchData(Map<String, dynamic>? params);
}

/// 低层模块
class NetworkFetcher extends DataFetcher {
  @override
  Future<Map<String, dynamic>?> fetchData(Map<String, dynamic>? params){
    // TODO: implement fetchData
    throw UnimplementedError();
  }

}

/// 低层模块
class DatabaseFetcher extends DataFetcher {
  @override
  Future<Map<String, dynamic>?> fetchData(Map<String, dynamic>? params){
    // TODO: implement fetchData
    throw UnimplementedError();
  }

}

/// 高层模块
class DataProvider {
  DataFetcher? _fetcher;

  init(DataFetcher fetcher) {
    _fetcher = fetcher;
  }

  Future<Map<String, dynamic>?> fetchData(Map<String, dynamic>? params) async {
    final map = _fetcher?.fetchData(params);
    return map;
  }

}