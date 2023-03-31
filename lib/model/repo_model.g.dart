// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RepoModel _$RepoModelFromJson(Map<String, dynamic> json) => RepoModel(
      data: (json['data'] as List<dynamic>)
          .map((e) => RepoModelData.fromJson(e as Map<String, dynamic>))
          .toList(),
      code: json['code'] as int,
      message: json['message'] as int,
    );

Map<String, dynamic> _$RepoModelToJson(RepoModel instance) => <String, dynamic>{
      'data': instance.data.map((e) => e.toJson()).toList(),
      'code': instance.code,
      'message': instance.message,
    };

RepoModelData _$RepoModelDataFromJson(Map<String, dynamic> json) =>
    RepoModelData(
      id: json['id'] as int?,
      nodeId: json['node_id'] as String?,
      name: json['name'] as String?,
      fullName: json['full_name'] as String?,
      private: json['private'] as bool?,
      owner: json['owner'] == null
          ? null
          : OwnerData.fromJson(json['owner'] as Map<String, dynamic>),
      htmlUrl: json['html_url'] as String?,
      description: json['description'] as String?,
      fork: json['fork'] as bool?,
      url: json['url'] as String?,
      forksUrl: json['forks_url'] as String?,
      keysUrl: json['keys_url'] as String?,
      collaboratorsUrl: json['collaborators_url'] as String?,
      teamsUrl: json['teams_url'] as String?,
      hooksUrl: json['hooks_url'] as String?,
      issueEventsUrl: json['issue_events_url'] as String?,
      eventsUrl: json['events_url'] as String?,
      assigneesUrl: json['assignees_url'] as String?,
      branchesUrl: json['branches_url'] as String?,
      tagsUrl: json['tags_url'] as String?,
      blobsUrl: json['blobs_url'] as String?,
      gitTagsUrl: json['git_tags_url'] as String?,
      gitRefsUrl: json['git_refs_url'] as String?,
      treesUrl: json['trees_url'] as String?,
      statusesUrl: json['statuses_url'] as String?,
      languagesUrl: json['languages_url'] as String?,
      stargazersUrl: json['stargazers_url'] as String?,
      contributorsUrl: json['contributors_url'] as String?,
      subscribers_url: json['subscribers_url'] as String?,
      subscription_url: json['subscription_url'] as String?,
      commits_url: json['commits_url'] as String?,
      git_commits_url: json['git_commits_url'] as String?,
      comments_url: json['comments_url'] as String?,
      issue_comment_url: json['issue_comment_url'] as String?,
      contents_url: json['contents_url'] as String?,
      compare_url: json['compare_url'] as String?,
      merges_url: json['merges_url'] as String?,
      archive_url: json['archive_url'] as String?,
      downloads_url: json['downloads_url'] as String?,
      issues_url: json['issues_url'] as String?,
      pulls_url: json['pulls_url'] as String?,
      milestones_url: json['milestones_url'] as String?,
      notifications_url: json['notifications_url'] as String?,
      labels_url: json['labels_url'] as String?,
      releases_url: json['releases_url'] as String?,
      deployments_url: json['deployments_url'] as String?,
      created_at: json['created_at'] as String?,
      updated_at: json['updated_at'] as String?,
      pushed_at: json['pushed_at'] as String?,
      git_url: json['git_url'] as String?,
      ssh_url: json['ssh_url'] as String?,
      clone_url: json['clone_url'] as String?,
      svn_url: json['svn_url'] as String?,
      homepage: json['homepage'] as String?,
      size: json['size'] as int?,
      stargazers_count: json['stargazers_count'] as int?,
      watchers_count: json['watchers_count'] as int?,
      language: json['language'] as String?,
      has_issues: json['has_issues'] as bool?,
      has_projects: json['has_projects'] as bool?,
      has_downloads: json['has_downloads'] as bool?,
      has_wiki: json['has_wiki'] as bool?,
      has_pages: json['has_pages'] as bool?,
      forks_count: json['forks_count'] as int?,
      mirror_url: json['mirror_url'],
      archived: json['archived'] as bool?,
      disabled: json['disabled'] as bool?,
      open_issues_count: json['open_issues_count'] as int?,
      license: json['license'] == null
          ? null
          : LicenseData.fromJson(json['license'] as Map<String, dynamic>),
      allow_forking: json['allow_forking'] as bool?,
      is_template: json['is_template'] as bool?,
      topics: (json['topics'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      visibility: json['visibility'] as String?,
      forks: json['forks'] as int?,
      open_issues: json['open_issues'] as int?,
      watchers: json['watchers'] as int?,
      default_branch: json['default_branch'] as String?,
      permissions: json['permissions'] == null
          ? null
          : PermissionsData.fromJson(
              json['permissions'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RepoModelDataToJson(RepoModelData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'node_id': instance.nodeId,
      'name': instance.name,
      'full_name': instance.fullName,
      'private': instance.private,
      'owner': instance.owner?.toJson(),
      'html_url': instance.htmlUrl,
      'description': instance.description,
      'fork': instance.fork,
      'url': instance.url,
      'forks_url': instance.forksUrl,
      'keys_url': instance.keysUrl,
      'collaborators_url': instance.collaboratorsUrl,
      'teams_url': instance.teamsUrl,
      'hooks_url': instance.hooksUrl,
      'issue_events_url': instance.issueEventsUrl,
      'events_url': instance.eventsUrl,
      'assignees_url': instance.assigneesUrl,
      'branches_url': instance.branchesUrl,
      'tags_url': instance.tagsUrl,
      'blobs_url': instance.blobsUrl,
      'git_tags_url': instance.gitTagsUrl,
      'git_refs_url': instance.gitRefsUrl,
      'trees_url': instance.treesUrl,
      'statuses_url': instance.statusesUrl,
      'languages_url': instance.languagesUrl,
      'stargazers_url': instance.stargazersUrl,
      'contributors_url': instance.contributorsUrl,
      'subscribers_url': instance.subscribers_url,
      'subscription_url': instance.subscription_url,
      'commits_url': instance.commits_url,
      'git_commits_url': instance.git_commits_url,
      'comments_url': instance.comments_url,
      'issue_comment_url': instance.issue_comment_url,
      'contents_url': instance.contents_url,
      'compare_url': instance.compare_url,
      'merges_url': instance.merges_url,
      'archive_url': instance.archive_url,
      'downloads_url': instance.downloads_url,
      'issues_url': instance.issues_url,
      'pulls_url': instance.pulls_url,
      'milestones_url': instance.milestones_url,
      'notifications_url': instance.notifications_url,
      'labels_url': instance.labels_url,
      'releases_url': instance.releases_url,
      'deployments_url': instance.deployments_url,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
      'pushed_at': instance.pushed_at,
      'git_url': instance.git_url,
      'ssh_url': instance.ssh_url,
      'clone_url': instance.clone_url,
      'svn_url': instance.svn_url,
      'homepage': instance.homepage,
      'size': instance.size,
      'stargazers_count': instance.stargazers_count,
      'watchers_count': instance.watchers_count,
      'language': instance.language,
      'has_issues': instance.has_issues,
      'has_projects': instance.has_projects,
      'has_downloads': instance.has_downloads,
      'has_wiki': instance.has_wiki,
      'has_pages': instance.has_pages,
      'forks_count': instance.forks_count,
      'mirror_url': instance.mirror_url,
      'archived': instance.archived,
      'disabled': instance.disabled,
      'open_issues_count': instance.open_issues_count,
      'license': instance.license?.toJson(),
      'allow_forking': instance.allow_forking,
      'is_template': instance.is_template,
      'topics': instance.topics,
      'visibility': instance.visibility,
      'forks': instance.forks,
      'open_issues': instance.open_issues,
      'watchers': instance.watchers,
      'default_branch': instance.default_branch,
      'permissions': instance.permissions?.toJson(),
    };

PermissionsData _$PermissionsDataFromJson(Map<String, dynamic> json) =>
    PermissionsData(
      admin: json['admin'] as bool?,
      maintain: json['maintain'] as bool?,
      push: json['push'] as bool?,
      triage: json['triage'] as bool?,
      pull: json['pull'] as bool?,
    );

Map<String, dynamic> _$PermissionsDataToJson(PermissionsData instance) =>
    <String, dynamic>{
      'admin': instance.admin,
      'maintain': instance.maintain,
      'push': instance.push,
      'triage': instance.triage,
      'pull': instance.pull,
    };

LicenseData _$LicenseDataFromJson(Map<String, dynamic> json) => LicenseData(
      key: json['key'] as String?,
      name: json['name'] as String?,
      spdx_id: json['spdx_id'] as String?,
      url: json['url'] as String?,
      node_id: json['node_id'] as String?,
    );

Map<String, dynamic> _$LicenseDataToJson(LicenseData instance) =>
    <String, dynamic>{
      'key': instance.key,
      'name': instance.name,
      'spdx_id': instance.spdx_id,
      'url': instance.url,
      'node_id': instance.node_id,
    };

OwnerData _$OwnerDataFromJson(Map<String, dynamic> json) => OwnerData(
      login: json['login'] as String?,
      id: json['id'] as int,
      node_id: json['node_id'] as String?,
      avatar_url: json['avatar_url'] as String?,
      gravatar_id: json['gravatar_id'] as String?,
      url: json['url'] as String?,
      html_url: json['html_url'] as String?,
      followers_url: json['followers_url'] as String?,
      following_url: json['following_url'] as String?,
      gists_url: json['gists_url'] as String?,
      starred_url: json['starred_url'] as String?,
      subscriptions_url: json['subscriptions_url'] as String?,
      organizations_url: json['organizations_url'] as String?,
      repos_url: json['repos_url'] as String?,
      events_url: json['events_url'] as String?,
      received_events_url: json['received_events_url'] as String?,
      type: json['type'] as String?,
      site_admin: json['site_admin'] as bool?,
    );

Map<String, dynamic> _$OwnerDataToJson(OwnerData instance) => <String, dynamic>{
      'login': instance.login,
      'id': instance.id,
      'node_id': instance.node_id,
      'avatar_url': instance.avatar_url,
      'gravatar_id': instance.gravatar_id,
      'url': instance.url,
      'html_url': instance.html_url,
      'followers_url': instance.followers_url,
      'following_url': instance.following_url,
      'gists_url': instance.gists_url,
      'starred_url': instance.starred_url,
      'subscriptions_url': instance.subscriptions_url,
      'organizations_url': instance.organizations_url,
      'repos_url': instance.repos_url,
      'events_url': instance.events_url,
      'received_events_url': instance.received_events_url,
      'type': instance.type,
      'site_admin': instance.site_admin,
    };
