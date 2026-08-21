//
//  Item.dart
//  flutter_templet_project
//
//  Created by shang on 10/13/21 2:05 PM.
//  Copyright © 10/13/21 shang. All rights reserved.
//

import 'package:flutter_templet_project/mixin/selectable_mixin.dart';

class OrderModel with SelectableMixin {
  OrderModel({
    required this.id,
    required this.name,
    required this.price,
  });

  int id = 0;
  String name = '';
  double price = 0;

  OrderModel.fromJson(Map json) {
    if (json.isEmpty) {
      return;
    }
    id = json["id"];
    price = json["price"];
    name = json["name"];
  }

  @override
  Map<String, dynamic> toJson() {
    var json = Map<String, dynamic>();
    json["name"] = name;
    json["id"] = id;
    json["price"] = price;
    return json;
  }

  @override
  String get selectableId => id.toString();

  @override
  String get selectableName => name;
}
