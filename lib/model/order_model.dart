//
//  Item.dart
//  flutter_templet_project
//
//  Created by shang on 10/13/21 2:05 PM.
//  Copyright © 10/13/21 shang. All rights reserved.
//


import 'package:flutter_templet_project/mixin/selectable_mixin.dart';



class OrderModel with SelectableMixin{

  OrderModel({
    required this.id,
    required this.name,
    required this.pirce,
  });

  int id = 0;
  String name = '';
  double pirce = 0;

  OrderModel.fromJson(Map json){
    if(json.isEmpty){
      return;
    }
    id = json["id"];
    pirce = json["pirce"];
    name = json["name"];
  }

  Map<String, dynamic> toJson(){
    var json = Map<String, dynamic>();
    json["name"] = name;
    json["id"] = id;
    json["pirce"] = pirce;
    return json;
  }

}