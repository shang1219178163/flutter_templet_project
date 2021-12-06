//
//  Item.dart
//  flutter_templet_project
//
//  Created by shang on 10/13/21 2:05 PM.
//  Copyright © 10/13/21 shang. All rights reserved.
//


class OrderModel{

  int id = 0;
  String name = '';
  double pirce = 0;

  OrderModel({
    required this.id,
    required this.name,
    required this.pirce,
  });

  OrderModel.fromJson(Map json){
    if(json.isEmpty){
      return;
    }
    id = json["id"];
    pirce = json["pirce"];
    name = json["name"].stringValue;
  }

  Map<String, dynamic> toJson(){
    var json = Map<String, dynamic>();
    json["name"] = name;
    json["id"] = id;
    json["pirce"] = pirce;
    return json;
  }

}