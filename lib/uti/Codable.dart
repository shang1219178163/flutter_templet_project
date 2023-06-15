


mixin CacheConversationMixin {

  /// 获取缓存会话列表
  // List<T> getCacheConversationList<T extends Codable>({required String key}) {
  //   final map = CacheService().getMap(key);
  //   final userID = CacheService().getUserID();
  //   if (map?.containsKey(userID) == true) {
  //     final cacheItems = map![userID] ?? [];
  //     final list = (cacheItems ?? <T>[]).map((e) {
  //       final map = jsonDecode(e);
  //       final model = T.fromJson(map);
  //       return model;
  //     }).toList();
  //     return List<T>.from(list);
  //   }
  //   return <T>[];
  // }

  // /// 缓存会话列表
  // cacheConversationList<T extends Codable>({required String key, required List<T?> list}) {
  //   if (list.isEmpty) {
  //     return;
  //   }
  //   final userID = CacheService().getUserID();
  //
  //   final cacheItems = list.map((e) {
  //     final map = e!.toJson();
  //     final str = jsonEncode(map);
  //     return str;
  //   }).toList();
  //
  //   final map = <String, dynamic>{"$userID": cacheItems};
  //   CacheService().setMap(key, map);
  // }
  //
  // ///删除部分会话
  // deleteCacheConversationList<T extends Codable>({required String key, required bool test(T e)}){
  //   final items = getCacheConversationList<T>(key: key);//add test
  //   // debugPrint("items.length:${items.length}");
  //
  //   final newItems = items.where((element) => test(element)).toList();
  //   cacheConversationList(key: key, list: newItems);
  // }


  // /// 获取缓存模型
  // T getCacheModel<T extends Codable>({required String key}) {
  //   final model = T.fromJson({});
  //   return model;
  // }
}


abstract class Codable {
  // factory Codable(Map<String, dynamic>? json) {
  //   throw UnimplementedError();
  // }

  factory Codable.fromJson(Map<String, dynamic>? json) {
    throw UnimplementedError();
  }

  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }
}
