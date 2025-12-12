class NewsMatchTeam {
  NewsMatchTeam({
    this.id,
    this.logo,
    this.names,
    this.sportId,
  });

  int? id;
  String? logo;
  String? names;
  int? sportId;

  NewsMatchTeam.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    logo = json['logo'];
    names = json['names'];
    sportId = json['sportId'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['logo'] = logo;
    data['names'] = names;
    data['sportId'] = sportId;
    return data;
  }
}
