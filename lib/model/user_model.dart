//
//  UserModel.dart
//  flutter_templet_project
//
//  Created by shang on 5/19/21 6:32 PM.
//  Copyright © 5/19/21 shang. All rights reserved.
//


import 'package:flutter_templet_project/mixin/selectable_mixin.dart';

class UserModel with SelectableMixin{
  UserModel({
    this.id,
    this.name,
    this.nickName,
    this.email,
    this.address,
    this.phone,
    this.website,
    this.company,
  });

  String? id;
  String? name;
  String? nickName;
  String? email;
  Address? address;
  String? phone;
  String? website;
  Company? company;

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nickName = json['nickName'];
    email = json['email'];
    address =
    json['address'] != null ? Address.fromJson(json['address']) : null;
    phone = json['phone'];
    website = json['website'];
    company =
    json['company'] != null ? Company.fromJson(json['company']) : null;

    isSelected = json['isSelected'] ?? false;
  }

  Map<String, dynamic> toJson() {
    var data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['nickName'] = nickName;
    data['email'] = email;
    if (address != null) {
      data['address'] = address!.toJson();
    }
    data['phone'] = phone;
    data['website'] = website;

    if (company != null) {
      data['company'] = company!.toJson();
    }

    data['isSelected'] = isSelected;
    return data;
  }
}

class Address {
  String? street;
  String? suite;
  String? city;
  String? zipcode;
  Coordinate? geo;

  Address({this.street, this.suite, this.city, this.zipcode, this.geo});

  Address.fromJson(Map<String, dynamic> json) {
    street = json['street'];
    suite = json['suite'];
    city = json['city'];
    zipcode = json['zipcode'];
    geo = json['geo'] != null ? Coordinate.fromJson(json['geo']) : null;
  }

  Map<String, dynamic> toJson() {
    var data = Map<String, dynamic>();
    data['street'] = street;
    data['suite'] = suite;
    data['city'] = city;
    data['zipcode'] = zipcode;
    if (geo != null) {
      data['geo'] = geo!.toJson();
    }
    return data;
  }
}

class Coordinate {
  String? lat;
  String? lng;

  Coordinate({this.lat, this.lng});

  Coordinate.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    var data = Map<String, dynamic>();
    data['lat'] = lat;
    data['lng'] = lng;
    return data;
  }
}

class Company {
  String? name;
  String? catchPhrase;
  String? bs;

  Company({this.name, this.catchPhrase, this.bs});

  Company.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    catchPhrase = json['catchPhrase'];
    bs = json['bs'];
  }

  Map<String, dynamic> toJson() {
    var data = Map<String, dynamic>();
    data['name'] = name;
    data['catchPhrase'] = catchPhrase;
    data['bs'] = bs;
    return data;
  }
}
