
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
  String? node_id;
  String? name;
  String? full_name;
  bool? private;
  OwnerData? owner;
  String? html_url;
  String? description;
  bool? fork;
  String? url;
  String? forks_url;
  String? keys_url;
  String? collaborators_url;
  String? teams_url;
  String? hooks_url;
  String? issue_events_url;
  String? events_url;
  String? assignees_url;
  String? branches_url;
  String? tags_url;
  String? blobs_url;
  String? git_tags_url;
  String? git_refs_url;
  String? trees_url;
  String? statuses_url;
  String? languages_url;
  String? stargazers_url;
  String? contributors_url;
  String? subscribers_url;
  String? subscription_url;
  String? commits_url;
  String? git_commits_url;
  String? comments_url;
  String? issue_comment_url;
  String? contents_url;
  String? compare_url;
  String? merges_url;
  String? archive_url;
  String? downloads_url;
  String? issues_url;
  String? pulls_url;
  String? milestones_url;
  String? notifications_url;
  String? labels_url;
  String? releases_url;
  String? deployments_url;
  String? created_at;
  String? updated_at;
  String? pushed_at;
  String? git_url;
  String? ssh_url;
  String? clone_url;
  String? svn_url;
  String? homepage;
  int? size;
  int? stargazers_count;
  int? watchers_count;
  String? language;
  bool? has_issues;
  bool? has_projects;
  bool? has_downloads;
  bool? has_wiki;
  bool? has_pages;
  int? forks_count;
  var mirror_url;
  bool? archived;
  bool? disabled;
  int? open_issues_count;
  LicenseData? license;
  bool? allow_forking;
  bool? is_template;
  List<String> topics;
  String? visibility;
  int? forks;
  int? open_issues;
  int? watchers;
  String? default_branch;
  PermissionsData? permissions;

  RepoModelData({
    this.id,
    this.node_id,
    this.name,
    this.full_name,
    this.private,
    this.owner,
    this.html_url,
    this.description,
    this.fork,
    this.url,
    this.forks_url,
    this.keys_url,
    this.collaborators_url,
    this.teams_url,
    this.hooks_url,
    this.issue_events_url,
    this.events_url,
    this.assignees_url,
    this.branches_url,
    this.tags_url,
    this.blobs_url,
    this.git_tags_url,
    this.git_refs_url,
    this.trees_url,
    this.statuses_url,
    this.languages_url,
    this.stargazers_url,
    this.contributors_url,
    this.subscribers_url,
    this.subscription_url,
    this.commits_url,
    this.git_commits_url,
    this.comments_url,
    this.issue_comment_url,
    this.contents_url,
    this.compare_url,
    this.merges_url,
    this.archive_url,
    this.downloads_url,
    this.issues_url,
    this.pulls_url,
    this.milestones_url,
    this.notifications_url,
    this.labels_url,
    this.releases_url,
    this.deployments_url,
    this.created_at,
    this.updated_at,
    this.pushed_at,
    this.git_url,
    this.ssh_url,
    this.clone_url,
    this.svn_url,
    this.homepage,
    this.size,
    this.stargazers_count,
    this.watchers_count,
    this.language,
    this.has_issues,
    this.has_projects,
    this.has_downloads,
    this.has_wiki,
    this.has_pages,
    this.forks_count,
    this.mirror_url,
    this.archived,
    this.disabled,
    this.open_issues_count,
    this.license,
    this.allow_forking,
    this.is_template,
    this.topics = const [],
    this.visibility,
    this.forks,
    this.open_issues,
    this.watchers,
    this.default_branch,
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
  String? spdx_id;
  String? url;
  String? node_id;

  LicenseData({
    this.key,
    this.name,
    this.spdx_id,
    this.url,
    this.node_id,
  });

  factory LicenseData.fromJson(Map<String, dynamic> json) => _$LicenseDataFromJson(json);
  Map<String, dynamic> toJson() => _$LicenseDataToJson(this);

}

@JsonSerializable(explicitToJson: true)
class OwnerData{
  String? login;
  int id;
  String? node_id;
  String? avatar_url;
  String? gravatar_id;
  String? url;
  String? html_url;
  String? followers_url;
  String? following_url;
  String? gists_url;
  String? starred_url;
  String? subscriptions_url;
  String? organizations_url;
  String? repos_url;
  String? events_url;
  String? received_events_url;
  String? type;
  bool? site_admin;

  OwnerData({
    this.login,
    required this.id,
    this.node_id = "",
    this.avatar_url,
    this.gravatar_id,
    this.url,
    this.html_url,
    this.followers_url,
    this.following_url,
    this.gists_url,
    this.starred_url,
    this.subscriptions_url,
    this.organizations_url,
    this.repos_url,
    this.events_url,
    this.received_events_url,
    this.type,
    this.site_admin,
  });

  factory OwnerData.fromJson(Map<String, dynamic> json) => _$OwnerDataFromJson(json);
  Map<String, dynamic> toJson() => _$OwnerDataToJson(this);

}

