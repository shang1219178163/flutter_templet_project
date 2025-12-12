/// 苹果商店应用详情
class AppstoreAppDetailRootModel {
  AppstoreAppDetailRootModel({
    this.resultCount,
    this.results = const [],
  });

  int? resultCount;
  List<AppstoreAppDetailModel>? results;

  AppstoreAppDetailRootModel.fromJson(Map<String, dynamic> json) {
    resultCount = json['resultCount'];
    if (json['results'] != null) {
      results = <AppstoreAppDetailModel>[];
      json['results'].forEach((v) {
        results!.add(AppstoreAppDetailModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['resultCount'] = resultCount;
    if (results != null) {
      data['results'] = results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

/// 苹果商店应用详情
class AppstoreAppDetailModel {
  AppstoreAppDetailModel(
      {this.supportedDevices,
      // this.features,
      this.isGameCenterEnabled,
      // this.advisories,
      this.screenshotUrls,
      this.ipadScreenshotUrls,
      this.appletvScreenshotUrls,
      this.artworkUrl60,
      this.artworkUrl512,
      this.artworkUrl100,
      this.artistViewUrl,
      this.kind,
      this.currentVersionReleaseDate,
      this.minimumOsVersion,
      this.releaseNotes,
      this.artistId,
      this.artistName,
      this.genres,
      this.price,
      this.description,
      this.genreIds,
      this.isVppDeviceBasedLicensingEnabled,
      this.bundleId,
      this.trackId,
      this.trackName,
      this.primaryGenreName,
      this.primaryGenreId,
      this.releaseDate,
      this.sellerName,
      this.currency,
      this.fileSizeBytes,
      this.sellerUrl,
      this.formattedPrice,
      this.contentAdvisoryRating,
      this.averageUserRatingForCurrentVersion,
      this.userRatingCountForCurrentVersion,
      this.averageUserRating,
      this.trackViewUrl,
      this.trackContentRating,
      this.trackCensoredName,
      this.languageCodesISO2A,
      this.version,
      this.wrapperType,
      this.userRatingCount});

  List<String>? supportedDevices;
  // List<Null>? features;
  bool? isGameCenterEnabled;
  // List<Null>? advisories;
  List<String>? screenshotUrls;
  List<String>? ipadScreenshotUrls;
  List<String>? appletvScreenshotUrls;
  String? artworkUrl60;
  String? artworkUrl512;
  String? artworkUrl100;
  String? artistViewUrl;
  String? kind;
  String? currentVersionReleaseDate;
  String? minimumOsVersion;
  String? releaseNotes;
  int? artistId;
  String? artistName;
  List<String>? genres;
  double? price;
  String? description;
  List<String>? genreIds;
  bool? isVppDeviceBasedLicensingEnabled;
  String? bundleId;
  int? trackId;
  String? trackName;
  String? primaryGenreName;
  int? primaryGenreId;
  String? releaseDate;
  String? sellerName;
  String? currency;
  String? fileSizeBytes;
  String? sellerUrl;
  String? formattedPrice;
  String? contentAdvisoryRating;
  int? averageUserRatingForCurrentVersion;
  int? userRatingCountForCurrentVersion;
  int? averageUserRating;
  String? trackViewUrl;
  String? trackContentRating;
  String? trackCensoredName;
  List<String>? languageCodesISO2A;
  String? version;
  String? wrapperType;
  int? userRatingCount;

  AppstoreAppDetailModel.fromJson(Map<String, dynamic> json) {
    supportedDevices = List<String>.from(json['supportedDevices'] ?? []);

    // if (json['features'] != null) {
    //   features = <Null>[];
    //   json['features'].forEach((v) {
    //     features!.add(Null.fromJson(v));
    //   });
    // }
    isGameCenterEnabled = json['isGameCenterEnabled'];
    // if (json['advisories'] != null) {
    //   advisories = <Null>[];
    //   json['advisories'].forEach((v) {
    //     advisories!.add(Null.fromJson(v));
    //   });
    // }
    screenshotUrls = List<String>.from(json['screenshotUrls'] ?? []);
    ipadScreenshotUrls = List<String>.from(json['ipadScreenshotUrls'] ?? []);
    appletvScreenshotUrls = List<String>.from(json['appletvScreenshotUrls'] ?? []);
    artworkUrl60 = json['artworkUrl60'];
    artworkUrl512 = json['artworkUrl512'];
    artworkUrl100 = json['artworkUrl100'];
    artistViewUrl = json['artistViewUrl'];
    kind = json['kind'];
    currentVersionReleaseDate = json['currentVersionReleaseDate'];
    minimumOsVersion = json['minimumOsVersion'];
    releaseNotes = json['releaseNotes'];
    artistId = json['artistId'];
    artistName = json['artistName'];
    genres = json['genres'].cast<String>();
    price = json['price'];
    description = json['description'];
    genreIds = json['genreIds'].cast<String>();
    isVppDeviceBasedLicensingEnabled = json['isVppDeviceBasedLicensingEnabled'];
    bundleId = json['bundleId'];
    trackId = json['trackId'];
    trackName = json['trackName'];
    primaryGenreName = json['primaryGenreName'];
    primaryGenreId = json['primaryGenreId'];
    releaseDate = json['releaseDate'];
    sellerName = json['sellerName'];
    currency = json['currency'];
    fileSizeBytes = json['fileSizeBytes'];
    sellerUrl = json['sellerUrl'];
    formattedPrice = json['formattedPrice'];
    contentAdvisoryRating = json['contentAdvisoryRating'];
    averageUserRatingForCurrentVersion = json['averageUserRatingForCurrentVersion'];
    userRatingCountForCurrentVersion = json['userRatingCountForCurrentVersion'];
    averageUserRating = json['averageUserRating'];
    trackViewUrl = json['trackViewUrl'];
    trackContentRating = json['trackContentRating'];
    trackCensoredName = json['trackCensoredName'];
    languageCodesISO2A = json['languageCodesISO2A'].cast<String>();
    version = json['version'];
    wrapperType = json['wrapperType'];
    userRatingCount = json['userRatingCount'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['supportedDevices'] = supportedDevices;
    // if (features != null) {
    //   data['features'] = features!.map((v) => v.toJson()).toList();
    // }
    data['isGameCenterEnabled'] = isGameCenterEnabled;
    // if (advisories != null) {
    //   data['advisories'] = advisories!.map((v) => v.toJson()).toList();
    // }
    data['screenshotUrls'] = screenshotUrls;
    data['ipadScreenshotUrls'] = ipadScreenshotUrls;
    data['appletvScreenshotUrls'] = appletvScreenshotUrls;
    data['screenshotUrls'] = screenshotUrls;
    data['artworkUrl60'] = artworkUrl60;
    data['artworkUrl512'] = artworkUrl512;
    data['artworkUrl100'] = artworkUrl100;
    data['artistViewUrl'] = artistViewUrl;
    data['kind'] = kind;
    data['currentVersionReleaseDate'] = currentVersionReleaseDate;
    data['minimumOsVersion'] = minimumOsVersion;
    data['releaseNotes'] = releaseNotes;
    data['artistId'] = artistId;
    data['artistName'] = artistName;
    data['genres'] = genres;
    data['price'] = price;
    data['description'] = description;
    data['genreIds'] = genreIds;
    data['isVppDeviceBasedLicensingEnabled'] = isVppDeviceBasedLicensingEnabled;
    data['bundleId'] = bundleId;
    data['trackId'] = trackId;
    data['trackName'] = trackName;
    data['primaryGenreName'] = primaryGenreName;
    data['primaryGenreId'] = primaryGenreId;
    data['releaseDate'] = releaseDate;
    data['sellerName'] = sellerName;
    data['currency'] = currency;
    data['fileSizeBytes'] = fileSizeBytes;
    data['sellerUrl'] = sellerUrl;
    data['formattedPrice'] = formattedPrice;
    data['contentAdvisoryRating'] = contentAdvisoryRating;
    data['averageUserRatingForCurrentVersion'] = averageUserRatingForCurrentVersion;
    data['userRatingCountForCurrentVersion'] = userRatingCountForCurrentVersion;
    data['averageUserRating'] = averageUserRating;
    data['trackViewUrl'] = trackViewUrl;
    data['trackContentRating'] = trackContentRating;
    data['trackCensoredName'] = trackCensoredName;
    data['languageCodesISO2A'] = languageCodesISO2A;
    data['version'] = version;
    data['wrapperType'] = wrapperType;
    data['userRatingCount'] = userRatingCount;
    return data;
  }
}
