class SongDetailModel {

  SongDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    lyric = json['sportId'];
    logo = json['logo'];
    name = json['names'];
  }
  SongDetailModel({
    this.id,
    this.lyric,
    this.logo,
    this.name,
  });

  int? id;

  String? lyric;

  String? logo;

  String? name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['sportId'] = lyric;
    map['logo'] = logo;
    map['names'] = name;
    return map;
  }
}
