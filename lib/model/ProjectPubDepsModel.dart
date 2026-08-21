//
//  ProjectPubDepsModel.dart
//
//  Created by JsonToModel on 2025-10-23 14:25.
//

// flutter 分析库的依赖关系
// flutter pub deps --json

class ProjectPubDepsModel {
  ProjectPubDepsModel({
    this.root,
    this.packages = const [],
    this.sdks = const [],
    this.executables = const [],
  });

  String? root;

  List<ProjectPackageModel>? packages;

  List<ProjectSdkModel>? sdks;

  List<String>? executables;

  ProjectPubDepsModel.fromJson(Map<String, dynamic> json) {
    root = json['root'];
    if (json['packages'] != null) {
      final array = List<Map<String, dynamic>>.from(json['packages'] ?? []);
      packages = array.map((e) => ProjectPackageModel.fromJson(e)).toList();
    }
    if (json['sdks'] != null) {
      final array = List<Map<String, dynamic>>.from(json['sdks'] ?? []);
      sdks = array.map((e) => ProjectSdkModel.fromJson(e)).toList();
    }

    if (json['executables'] != null) {
      executables = List<String>.from(json['executables'] ?? []);
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['root'] = root;
    map['packages'] = packages?.map((v) => v.toJson()).toList();
    map['sdks'] = sdks?.map((v) => v.toJson()).toList();
    map['executables'] = executables;
    return map;
  }

  @override
  String toString() {
    return "$runtimeType ${toJson()}";
  }
}

class ProjectPackageModel {
  ProjectPackageModel({
    this.name,
    this.version,
    this.kind,
    this.source,
    this.dependencies,
  });

  String? name;

  String? version;

  String? kind;

  String? source;

  List<String>? dependencies;

  ProjectPackageModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    version = json['version'];
    kind = json['kind'];
    source = json['source'];

    if (json['dependencies'] != null) {
      dependencies = List<String>.from(json['dependencies'] ?? []);
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['version'] = version;
    map['kind'] = kind;
    map['source'] = source;
    map['dependencies'] = dependencies;
    return map;
  }

  @override
  String toString() {
    return "$runtimeType ${toJson()}";
  }
}

class ProjectSdkModel {
  ProjectSdkModel({
    this.name,
    this.version,
  });

  String? name;

  String? version;

  ProjectSdkModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    version = json['version'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['version'] = version;
    return map;
  }

  @override
  String toString() {
    return "$runtimeType ${toJson()}";
  }
}
