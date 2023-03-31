
import 'package:json_annotation/json_annotation.dart';
part 'repo_model.g.dart';

@JsonSerializable(explicitToJson: true)
class RepoModel {
  List<RepoModelData> data;
  int code;
  int message;
  RepoModel({
    required this.data,
    required this.code,
    required this.message
  });

  factory RepoModel.fromJson(Map<String, dynamic> json) => _$RepoModelFromJson(json);
  Map<String, dynamic> toJson() => _$RepoModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class RepoModelData {
  int? id;
  String? nodeId;
  String? name;
  String? fullName;
  bool? private;
  OwnerData? owner;
  String? htmlUrl;
  String? description;
  bool? fork;
  String? url;
  String? forksUrl;
  String? keysUrl;
  String? collaboratorsUrl;
  String? teamsUrl;
  String? hooksUrl;
  String? issueEventsUrl;
  String? eventsUrl;
  String? assigneesUrl;
  String? branchesUrl;
  String? tagsUrl;
  String? blobsUrl;
  String? gitTagsUrl;
  String? gitRefsUrl;
  String? treesUrl;
  String? statusesUrl;
  String? languagesUrl;
  String? stargazersUrl;
  String? contributorsUrl;
  String? subscribersUrl;
  String? subscriptionUrl;
  String? commitsUrl;
  String? gitCommitsUrl;
  String? commentsUrl;
  String? issueCommentUrl;
  String? contentsUrl;
  String? compareUrl;
  String? mergesUrl;
  String? archiveUrl;
  String? downloadsUrl;
  String? issuesUrl;
  String? pullsUrl;
  String? milestonesUrl;
  String? notificationsUrl;
  String? labelsUrl;
  String? releasesUrl;
  String? deploymentsUrl;
  String? createdAt;
  String? updatedAt;
  String? pushedAt;
  String? gitUrl;
  String? sshUrl;
  String? cloneUrl;
  String? svnUrl;
  String? homepage;
  int? size;
  int? stargazersCount;
  int? watchersCount;
  String? language;
  bool? hasIssues;
  bool? hasProjects;
  bool? hasDownloads;
  bool? hasWiki;
  bool? hasPages;
  int? forksCount;
  String? mirrorUrl;
  bool? archived;
  bool? disabled;
  int? openIssuesCount;
  LicenseData? license;
  bool? allowForking;
  bool? isTemplate;
  List<String> topics;
  String? visibility;
  int? forks;
  int? openIssues;
  int? watchers;
  String? defaultBranch;
  PermissionsData? permissions;

  RepoModelData({
    this.id,
    this.nodeId,
    this.name,
    this.fullName,
    this.private,
    this.owner,
    this.htmlUrl,
    this.description,
    this.fork,
    this.url,
    this.forksUrl,
    this.keysUrl,
    this.collaboratorsUrl,
    this.teamsUrl,
    this.hooksUrl,
    this.issueEventsUrl,
    this.eventsUrl,
    this.assigneesUrl,
    this.branchesUrl,
    this.tagsUrl,
    this.blobsUrl,
    this.gitTagsUrl,
    this.gitRefsUrl,
    this.treesUrl,
    this.statusesUrl,
    this.languagesUrl,
    this.stargazersUrl,
    this.contributorsUrl,
    this.subscribersUrl,
    this.subscriptionUrl,
    this.commitsUrl,
    this.gitCommitsUrl,
    this.commentsUrl,
    this.issueCommentUrl,
    this.contentsUrl,
    this.compareUrl,
    this.mergesUrl,
    this.archiveUrl,
    this.downloadsUrl,
    this.issuesUrl,
    this.pullsUrl,
    this.milestonesUrl,
    this.notificationsUrl,
    this.labelsUrl,
    this.releasesUrl,
    this.deploymentsUrl,
    this.createdAt,
    this.updatedAt,
    this.pushedAt,
    this.gitUrl,
    this.sshUrl,
    this.cloneUrl,
    this.svnUrl,
    this.homepage,
    this.size,
    this.stargazersCount,
    this.watchersCount,
    this.language,
    this.hasIssues,
    this.hasProjects,
    this.hasDownloads,
    this.hasWiki,
    this.hasPages,
    this.forksCount,
    this.mirrorUrl,
    this.archived,
    this.disabled,
    this.openIssuesCount,
    this.license,
    this.allowForking,
    this.isTemplate,
    this.topics = const [],
    this.visibility,
    this.forks,
    this.openIssues,
    this.watchers,
    this.defaultBranch,
    this.permissions,
  });

  factory RepoModelData.fromJson(Map<String, dynamic> json) => _$RepoModelDataFromJson(json);
  Map<String, dynamic> toJson() => _$RepoModelDataToJson(this);
}

@JsonSerializable(explicitToJson: true)
class PermissionsData{
  bool? admin;
  bool? maintain;
  bool? push;
  bool? triage;
  bool? pull;

  PermissionsData({
    this.admin,
    this.maintain,
    this.push,
    this.triage,
    this.pull,
  });

  factory PermissionsData.fromJson(Map<String, dynamic> json) => _$PermissionsDataFromJson(json);
  Map<String, dynamic> toJson() => _$PermissionsDataToJson(this);

}

@JsonSerializable(explicitToJson: true)
class LicenseData{
  String? key;
  String? name;
  String? spdxId;
  String? url;
  String? nodeId;

  LicenseData({
    this.key,
    this.name,
    this.spdxId,
    this.url,
    this.nodeId,
  });

  factory LicenseData.fromJson(Map<String, dynamic> json) => _$LicenseDataFromJson(json);
  Map<String, dynamic> toJson() => _$LicenseDataToJson(this);

}

@JsonSerializable(explicitToJson: true)
class OwnerData{
  String? login;
  int id;
  String? nodeId;
  String? avatarUrl;
  String? gravatarId;
  String? url;
  String? htmlUrl;
  String? followersUrl;
  String? followingUrl;
  String? gistsUrl;
  String? starredUrl;
  String? subscriptionsUrl;
  String? organizationsUrl;
  String? reposUrl;
  String? eventsUrl;
  String? receivedEventsUrl;
  String? type;
  bool? siteAdmin;

  OwnerData({
    this.login,
    required this.id,
    this.nodeId,
    this.avatarUrl,
    this.gravatarId,
    this.url,
    this.htmlUrl,
    this.followersUrl,
    this.followingUrl,
    this.gistsUrl,
    this.starredUrl,
    this.subscriptionsUrl,
    this.organizationsUrl,
    this.reposUrl,
    this.eventsUrl,
    this.receivedEventsUrl,
    this.type,
    this.siteAdmin,
  });

  factory OwnerData.fromJson(Map<String, dynamic> json) => _$OwnerDataFromJson(json);
  Map<String, dynamic> toJson() => _$OwnerDataToJson(this);

}

